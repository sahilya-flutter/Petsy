import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_management_app/app/data/model/appointment_model.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../controllers/appointment_controller.dart';
import '../../pet/controllers/pet_controller.dart';
import '../../../routes/app_routes.dart';

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentController = Get.find<AppointmentController>();
    final petController = Get.find<PetController>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          backgroundColor: Colors.purple,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: Obx(() {
          if (appointmentController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            children: [
              // Upcoming Appointments
              _buildAppointmentList(
                appointmentController.upcomingAppointments,
                petController,
                appointmentController,
                isEmpty: 'No upcoming appointments',
              ),

              // Past Appointments
              _buildAppointmentList(
                appointmentController.pastAppointments,
                petController,
                appointmentController,
                isEmpty: 'No past appointments',
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(AppRoutes.ADD_APPOINTMENT),
          backgroundColor: Colors.purple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(
    List<AppointmentModel> appointments,
    PetController petController,
    AppointmentController appointmentController, {
    required String isEmpty,
  }) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 80.sp,
              color: Colors.grey[300],
            ),
            SizedBox(height: 2.h),
            Text(
              isEmpty,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => appointmentController.loadAppointments(),
      child: ListView.builder(
        padding: EdgeInsets.all(3.w),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final pet = petController.pets.firstWhereOrNull(
            (p) => p.id == appointment.petId,
          );

          return _buildAppointmentCard(
            appointment,
            pet?.name ?? 'Unknown Pet',
            appointmentController,
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
    AppointmentModel appointment,
    String petName,
    AppointmentController controller,
  ) {
    final isUpcoming = appointment.appointmentDate.isAfter(DateTime.now());

    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: appointment.isCompleted
                        ? Colors.green.shade100
                        : (isUpcoming
                              ? Colors.blue.shade100
                              : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    appointment.isCompleted
                        ? Icons.check_circle
                        : Icons.calendar_today,
                    color: appointment.isCompleted
                        ? Colors.green
                        : (isUpcoming ? Colors.blue : Colors.grey),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          decoration: appointment.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Icon(Icons.pets, size: 12.sp, color: Colors.grey),
                          SizedBox(width: 1.w),
                          Text(
                            petName,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            appointment.isCompleted
                                ? Icons.remove_done
                                : Icons.check,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            appointment.isCompleted
                                ? 'Mark Incomplete'
                                : 'Mark Complete',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'toggle') {
                      controller.toggleComplete(appointment);
                    } else if (value == 'delete') {
                      _confirmDelete(appointment, controller);
                    }
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),
            Divider(),
            SizedBox(height: 1.h),

            // Date & Time
            Row(
              children: [
                Icon(Icons.access_time, size: 14.sp, color: Colors.purple),
                SizedBox(width: 2.w),
                Text(
                  DateFormat(
                    'MMM dd, yyyy • hh:mm a',
                  ).format(appointment.appointmentDate),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Location
            Row(
              children: [
                Icon(Icons.location_on, size: 14.sp, color: Colors.purple),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    appointment.location,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            if (appointment.description != null &&
                appointment.description!.isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes, size: 14.sp, color: Colors.purple),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      appointment.description!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    AppointmentModel appointment,
    AppointmentController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Appointment'),
        content: Text(
          'Are you sure you want to delete "${appointment.title}"?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAppointment(appointment.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
