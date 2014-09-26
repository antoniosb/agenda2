Appointment 2 Services
======================

Sample Rails application that allows user to schedule services using pre-provided time slots

Visit the [demo](http://appointment2services.herokuapp.com/). You can use the default `admin@admin.org / admin` user to get access to the admin features, such as:

* CRUD Services
* CRUD Appointments
* Change Appointment status by clicking over it status name on index page

Another cool features:
----------------------

* The appointments that is overdue has its status automatically updated. 
* Massive deletion of appointments (admin only).
* Account creation/confirmation handled by devise.
* Responsive* layout

Appointment Status Rules:
-------------------------

1. A normal user can only create appointments for itself.
2. A normal user can only edit its appointments status to canceled, and only if it is on pending status. 
3. An admin user can create appointments for every user.
4. An admin user can edit all appointments that are either pending or confirmed. 
5. Thus, appointments with status canceled, concluded and overdue can't be modified anymore.

Appointment Schedules Rules:
----------------------------

1. There will be a range of available time slots with 15 min step, from the present beginning of the current hour to a week further.
2. The time slots already taken (there is an appointment pending or confirmed for this time slot) are not shown on the available time slots.
3. The time slots for appointments on overdue, canceled and concluded status become available for a schedule if it matches the criteria on #1.

All the broadcasting views update are handled with AJAX as well as the available time slots for appointment.

`All the appointments creation/changes are broadcasted to all interested users (admin/targeted user) via a Faye Server.`

This application is still under construction / refactoring, so if you wanna contribute I'll be glad for your help!

(=
`@xtrdev`
