using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static Tarea1.AppCode.Models;

namespace Tarea1.AppCode
{
    public class DataStore
    {
         private static readonly object locker = new object();

        public static List<User> users = new List<User>();
        public static List<Activity> activities = new List<Activity>();

        // inicializa un admin por defecto (solo una vez)
        public static void EnsureSeed()
        {
            lock (locker)
            {
                if (users.Any()) return;

                users.Add(new User
                {
                    userId = Guid.NewGuid().ToString("N"),
                    idType = "Fisica",
                    idNumber = "000000000",
                    firstName = "Admin",
                    lastName = "Sistema",
                    birthDate = new DateTime(1990, 1, 1),
                    filialNumber = 0,
                    hasConstruction = true,
                    email = "admin@condominio.com",
                    passwordHash = SecurityHelper.HashPassword("Admin123!"),
                    role = UserRole.Admin,
                    createdAt = DateTime.Now
                });
            }
        }

        public static bool EmailExists(string email)
        {
            lock (locker)
            {
                return users.Any(u => u.email.Equals(email, StringComparison.OrdinalIgnoreCase));
            }
        }

        public static User FindUserByEmail(string email)
        {
            lock (locker)
            {
                return users.FirstOrDefault(u => u.email.Equals(email, StringComparison.OrdinalIgnoreCase));
            }
        }

        public static void AddUser(User user)
        {
            lock (locker)
            {
                users.Add(user);
            }
        }

        public static List<User> GetUsers()
        {
            lock (locker)
            {
                return users
                    .OrderByDescending(u => u.createdAt)
                    .ToList();
            }
        }

        public static void UpsertActivity(Activity activity)
        {
            lock (locker)
            {
                var existing = activities.FirstOrDefault(a => a.activityId == activity.activityId);
                if (existing == null)
                {
                    activities.Add(activity);
                }
                else
                {
                    // update campos
                    existing.activityType = activity.activityType;
                    existing.title = activity.title;
                    existing.forAll = activity.forAll;
                    existing.filialNumber = activity.filialNumber;
                    existing.publishStart = activity.publishStart;
                    existing.publishEnd = activity.publishEnd;

                    existing.meetingUrl = activity.meetingUrl;
                    existing.meetingAgenda = activity.meetingAgenda;

                    existing.place = activity.place;
                    existing.eventDate = activity.eventDate;
                    existing.requirements = activity.requirements;

                    existing.reminderText = activity.reminderText;

                    existing.updatedAt = DateTime.Now;
                }
            }
        }

        public static bool DeleteActivity(string activityId, out string message)
        {
            lock (locker)
            {
                var existing = activities.FirstOrDefault(a => a.activityId == activityId);
                if (existing == null)
                {
                    message = "No existe la actividad a eliminar.";
                    return false;
                }

                
                if (DateTime.Now >= existing.publishStart)
                {
                    message = "No se puede eliminar una actividad cuando la fecha de inicio ya pasó.";
                    return false;
                }

                activities.Remove(existing);
                message = "Actividad eliminada.";
                return true;
            }
        }

        public static List<Activity> GetActivitiesForAdmin(int? typeFilter = null)
        {
            lock (locker)
            {
                var now = DateTime.Now;

                var query = activities
                    .Where(a => now <= a.publishEnd) // ocultar por fecha cierre
                    .AsQueryable();

                if (typeFilter.HasValue && typeFilter.Value > 0)
                    query = query.Where(a => (int)a.activityType == typeFilter.Value);

                return query
                    .OrderBy(a => a.publishStart)
                    .ToList();
            }
        }

        public static List<Activity> GetActivitiesForUser(User user, int? typeFilter = null)
        {
            lock (locker)
            {
                var now = DateTime.Now;

                var query = activities
                    .Where(a => now <= a.publishEnd) // ocultar por cierre
                    .Where(a =>
                        a.forAll ||
                        (!a.forAll && a.filialNumber.HasValue && a.filialNumber.Value == user.filialNumber)
                    )
                    .AsQueryable();

                if (typeFilter.HasValue && typeFilter.Value > 0)
                    query = query.Where(a => (int)a.activityType == typeFilter.Value);

                return query
                    .OrderBy(a => a.publishStart)
                    .ToList();
            }
        }

        public static Activity FindActivityById(string activityId)
        {
            lock (locker)
            {
                return activities.FirstOrDefault(a => a.activityId == activityId);
            }
        }
    }
}