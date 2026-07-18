import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:berber_sepeti_is_ortagim/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/services/domain/entities/service.dart';
import 'package:berber_sepeti_is_ortagim/features/services/presentation/bloc/services_bloc.dart';

class AddEditServicePage extends StatefulWidget {
  final Service? service;

  const AddEditServicePage({super.key, this.service});

  @override
  State<AddEditServicePage> createState() => _AddEditServicePageState();
}

class _AddEditServicePageState extends State<AddEditServicePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController = TextEditingController(text: widget.service?.price.toString() ?? '');
    _durationController = TextEditingController(text: widget.service?.durationMinutes.toString() ?? '');
    _isActive = widget.service?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final barberShopId = authState.user.barberShopId;
        if (barberShopId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dükkan bilgisi bulunamadı.')),
          );
          return;
        }

        final newService = Service(
          id: widget.service?.id ?? const Uuid().v4(),
          barberShopId: barberShopId,
          name: _nameController.text.trim(),
          price: double.parse(_priceController.text.trim()),
          durationMinutes: int.parse(_durationController.text.trim()),
          isActive: _isActive,
        );

        if (widget.service == null) {
          context.read<ServicesBloc>().add(AddServiceEvent(service: newService));
        } else {
          context.read<ServicesBloc>().add(UpdateServiceEvent(service: newService));
        }

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.service != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Hizmeti Düzenle' : 'Yeni Hizmet Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Hizmet Adı',
                  hintText: 'Örn: Saç Kesimi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.content_cut),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen hizmet adını girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      decoration: const InputDecoration(
                        labelText: 'Fiyat (₺)',
                        hintText: '150',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Zorunlu.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Süre (Dk)',
                        hintText: '30',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Zorunlu.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Aktif mi?'),
                subtitle: const Text('Pasif yaparsanız müşteriler bu hizmeti seçemez.'),
                value: _isActive,
                onChanged: (val) {
                  setState(() {
                    _isActive = val;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveService,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isEditing ? 'Değişiklikleri Kaydet' : 'Hizmeti Ekle',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
