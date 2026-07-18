import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/domain/entities/working_hours.dart';
import 'package:berber_sepeti_is_ortagim/features/working_hours/presentation/bloc/working_hours_bloc.dart';

class WorkingHoursPage extends StatefulWidget {
  const WorkingHoursPage({super.key});

  @override
  State<WorkingHoursPage> createState() => _WorkingHoursPageState();
}

class _WorkingHoursPageState extends State<WorkingHoursPage> {
  // Gün isimleri (1=Pzt, 7=Pzr)
  final Map<int, String> _dayNames = {
    1: 'Pazartesi',
    2: 'Salı',
    3: 'Çarşamba',
    4: 'Perşembe',
    5: 'Cuma',
    6: 'Cumartesi',
    7: 'Pazar',
  };

  // Local state to track modifications before saving
  List<WorkingHours>? _editableHours;

  @override
  void initState() {
    super.initState();
    _loadHours();
  }

  void _loadHours() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final barberShopId = authState.user.barberShopId;
      if (barberShopId != null) {
        context.read<WorkingHoursBloc>().add(LoadWorkingHoursEvent(barberShopId: barberShopId));
      }
    }
  }

  Future<void> _selectTime(BuildContext context, int index, bool isOpening) async {
    final currentHourStr = isOpening ? _editableHours![index].openingTime : _editableHours![index].closingTime;
    final parts = currentHourStr.split(':');
    final initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        final old = _editableHours![index];
        
        _editableHours![index] = WorkingHours(
          id: old.id,
          barberShopId: old.barberShopId,
          dayOfWeek: old.dayOfWeek,
          openingTime: isOpening ? formattedTime : old.openingTime,
          closingTime: isOpening ? old.closingTime : formattedTime,
          isClosed: old.isClosed,
        );
      });
    }
  }

  void _saveChanges() {
    if (_editableHours == null) return;
    
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final barberShopId = authState.user.barberShopId;
      if (barberShopId != null) {
        context.read<WorkingHoursBloc>().add(
          SaveWorkingHoursEvent(
            workingHours: _editableHours!,
            barberShopId: barberShopId,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çalışma Saatleri'),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Kaydet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: BlocConsumer<WorkingHoursBloc, WorkingHoursState>(
        listener: (context, state) {
          if (state is WorkingHoursActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is WorkingHoursError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is WorkingHoursLoaded) {
            // State geldiğinde local state'e kopya alıyoruz ki üzerinde oynayabilelim
            _editableHours = List.from(state.workingHours);
          }
        },
        builder: (context, state) {
          if (state is WorkingHoursLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_editableHours == null || _editableHours!.isEmpty) {
            return const Center(child: Text('Veri bulunamadı.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _editableHours!.length,
            itemBuilder: (context, index) {
              final day = _editableHours![index];
              final dayName = _dayNames[day.dayOfWeek] ?? 'Bilinmeyen Gün';

              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: day.isClosed ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Row(
                            children: [
                              Text(day.isClosed ? 'Kapalı' : 'Açık', style: TextStyle(color: day.isClosed ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                              Switch(
                                value: !day.isClosed, // Switch True = Açık
                                onChanged: (val) {
                                  setState(() {
                                    _editableHours![index] = WorkingHours(
                                      id: day.id,
                                      barberShopId: day.barberShopId,
                                      dayOfWeek: day.dayOfWeek,
                                      openingTime: day.openingTime,
                                      closingTime: day.closingTime,
                                      isClosed: !val,
                                    );
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!day.isClosed) ...[
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text('Açılış', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                InkWell(
                                  onTap: () => _selectTime(context, index, true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(day.openingTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                                  ),
                                ),
                              ],
                            ),
                            const Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                            Column(
                              children: [
                                const Text('Kapanış', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                InkWell(
                                  onTap: () => _selectTime(context, index, false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(day.closingTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
