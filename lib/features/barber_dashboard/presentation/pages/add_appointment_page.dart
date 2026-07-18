import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/domain/entities/appointment.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/presentation/bloc/services_bloc.dart';

class AddAppointmentPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddAppointmentPage({super.key, required this.selectedDate});

  @override
  State<AddAppointmentPage> createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  Service? _selectedService;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Hizmetleri yükle
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final barberShopId = authState.user.barberShopId;
      if (barberShopId != null) {
        context.read<ServicesBloc>().add(LoadServicesEvent(barberShopId: barberShopId));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      if (_selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen bir hizmet seçin')),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final barberShopId = authState.user.barberShopId;
        final barberShopName = authState.user.name ?? 'Berber';

        if (barberShopId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dükkan bilgisi bulunamadı.')),
          );
          return;
        }

        // Tarih ve saati birleştir
        final appointmentDate = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final newAppointment = Appointment(
          id: const Uuid().v4(),
          barberShopId: barberShopId,
          barberShopName: barberShopName,
          customerName: _nameController.text.trim(),
          userId: null, // Manuel randevularda kullanıcı ID'si yok
          serviceId: _selectedService!.id,
          serviceName: _selectedService!.name,
          servicePrice: _selectedService!.price,
          appointmentDate: appointmentDate,
          serviceDurationMinutes: _selectedService!.durationMinutes,
          status: AppointmentStatus.confirmed, // Berber kendi eklediği için direkt onaylı
          notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
          createdAt: DateTime.now(),
        );

        context.read<BarberDashboardBloc>().add(
          CreateAppointmentEvent(
            appointment: newAppointment,
            barberShopId: barberShopId,
            selectedDate: widget.selectedDate,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Randevu Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarih ve Saat Seçimi
              Card(
                elevation: 0,
                color: Colors.blue.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Randevu Tarihi', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMMM yyyy, EEEE', 'tr_TR').format(widget.selectedDate),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Müşteri Bilgileri
              const Text('Müşteri Bilgileri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Müşteri Adı Soyadı',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen müşteri adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası (Opsiyonel)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Hizmet Seçimi
              const Text('Hizmet Seçimi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, state) {
                  if (state is ServicesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ServicesLoaded) {
                    final activeServices = state.services.where((s) => s.isActive).toList();
                    if (activeServices.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Text(
                          'Aktif bir hizmet bulunamadı. Lütfen önce "Hizmetler" sekmesinden hizmet ekleyin.',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      );
                    }

                    return DropdownButtonFormField<Service>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.content_cut),
                      ),
                      hint: const Text('Hizmet Seçin'),
                      value: _selectedService,
                      isExpanded: true,
                      items: activeServices.map((service) {
                        return DropdownMenuItem(
                          value: service,
                          child: Text('${service.name} (${service.price} ₺ - ${service.durationMinutes} dk)'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedService = val;
                        });
                      },
                      validator: (val) => val == null ? 'Lütfen hizmet seçin' : null,
                    );
                  }
                  return const Text('Hizmetler yüklenemedi.');
                },
              ),
              const SizedBox(height: 24),

              // Notlar
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notlar (Opsiyonel)',
                  hintText: 'Örn: Sadece saç kesimi yapılacak',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),

              // Kaydet Butonu
              ElevatedButton(
                onPressed: _saveAppointment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Randevuyu Kaydet', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
