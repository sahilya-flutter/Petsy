import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../pet/controllers/pet_controller.dart';
import '../../appointment/controllers/appointment_controller.dart';
import '../../reminder/controllers/reminder_controller.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final petController = Get.find<PetController>();
    final appointmentController = Get.find<AppointmentController>();
    final reminderController = Get.find<ReminderController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            'Hello, ${authController.currentUser.value?.name ?? "User"}!',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            petController.loadPets(),
            appointmentController.loadAppointments(),
            reminderController.loadReminders(),
          ]);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Stats
              _buildQuickStats(
                petController,
                appointmentController,
                reminderController,
              ),

              SizedBox(height: 3.h),

              // Today's Reminders
              _buildSection(
                title: 'Today\'s Reminders',
                onViewAll: () => Get.toNamed(AppRoutes.REMINDERS),
                child: Obx(() {
                  final todayReminders = reminderController.todayReminders;
                  if (todayReminders.isEmpty) {
                    return _buildEmptyState('No reminders for today');
                  }
                  return Column(
                    children: todayReminders.take(3).map((reminder) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 1.h),
                        child: ListTile(
                          leading: const Icon(
                            Icons.alarm,
                            color: Colors.orange,
                          ),
                          title: Text(reminder.title),
                          subtitle: Text(
                            DateFormat('hh:mm a').format(reminder.reminderDate),
                          ),
                          trailing: Text(
                            reminder.frequency.toUpperCase(),
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),

              SizedBox(height: 3.h),

              // Upcoming Appointments
              _buildSection(
                title: 'Upcoming Appointments',
                onViewAll: () => Get.toNamed(AppRoutes.APPOINTMENTS),
                child: Obx(() {
                  final upcoming = appointmentController.upcomingAppointments;
                  if (upcoming.isEmpty) {
                    return _buildEmptyState('No upcoming appointments');
                  }
                  return Column(
                    children: upcoming.take(3).map((appointment) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 1.h),
                        child: ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),
                          title: Text(appointment.title),
                          subtitle: Text(
                            DateFormat(
                              'MMM dd, yyyy - hh:mm a',
                            ).format(appointment.appointmentDate),
                          ),
                          trailing: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 18.sp,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),

              SizedBox(height: 3.h),

              // My Pets
              _buildSection(
                title: 'My Pets',
                onViewAll: () => Get.toNamed(AppRoutes.PET_LIST),
                child: Obx(() {
                  if (petController.pets.isEmpty) {
                    return _buildEmptyState('No pets added yet');
                  }
                  return SizedBox(
                    height: 20.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petController.pets.length,
                      itemBuilder: (context, index) {
                        final pet = petController.pets[index];
                        return Container(
                          width: 35.w,
                          margin: EdgeInsets.only(right: 3.w),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 25.sp,
                                    backgroundColor: Colors.purple.shade100,
                                    child: Icon(
                                      Icons.pets,
                                      size: 30.sp,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    pet.name,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    pet.species,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuickAddDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildQuickStats(
    PetController petController,
    AppointmentController appointmentController,
    ReminderController reminderController,
  ) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildStatCard(
              icon: Icons.pets,
              count: petController.pets.length,
              label: 'Pets',
              color: Colors.purple,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Obx(
            () => _buildStatCard(
              icon: Icons.calendar_today,
              count: appointmentController.upcomingAppointments.length,
              label: 'Appointments',
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Obx(
            () => _buildStatCard(
              icon: Icons.alarm,
              count: reminderController.activeReminders.length,
              label: 'Reminders',
              color: Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 1.h),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 9.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required VoidCallback onViewAll,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: onViewAll, child: Text('View All')),
          ],
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
        ),
      ),
    );
  }

  void _showQuickAddDialog() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Add',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: const Icon(Icons.pets, color: Colors.purple),
              title: const Text('Add Pet'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.ADD_PET);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: const Text('Add Appointment'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.ADD_APPOINTMENT);
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm, color: Colors.orange),
              title: const Text('Add Reminder'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.ADD_REMINDER);
              },
            ),
          ],
        ),
      ),
    );
  }
}
