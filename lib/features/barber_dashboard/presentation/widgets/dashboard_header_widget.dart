import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:berber_sepeti_is_ortagim/features/barber_dashboard/presentation/bloc/barber_dashboard_bloc.dart';

/// Pano üst bilgi widget'ı - tarih seçimi ve özet bilgiler.
class DashboardHeaderWidget extends StatelessWidget {
  final DateTime selectedDate;

  const DashboardHeaderWidget({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, EEEE', 'tr_TR');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final previousDay =
                  selectedDate.subtract(const Duration(days: 1));
              context
                  .read<BarberDashboardBloc>()
                  .add(ChangeDateEvent(newDate: previousDay));
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              dateFormat.format(selectedDate),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          IconButton(
            onPressed: () {
              final nextDay = selectedDate.add(const Duration(days: 1));
              context
                  .read<BarberDashboardBloc>()
                  .add(ChangeDateEvent(newDate: nextDay));
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
