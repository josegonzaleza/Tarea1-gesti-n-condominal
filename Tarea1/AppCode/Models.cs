using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tarea1.AppCode
{
    public class Models
    {

        public enum UserRole
        {
            Admin = 1,
            Condominio = 2
        }

        public enum ActivityType
        {
            Reunion = 1,
            Social = 2,
            Recordatorio = 3
        }

        public class User
        {
            public string userId { get; set; }                 
            public string idType { get; set; }                 
            public string idNumber { get; set; }
            public string firstName { get; set; }
            public string lastName { get; set; }
            public DateTime birthDate { get; set; }
            public int filialNumber { get; set; }
            public bool hasConstruction { get; set; }
            public string email { get; set; }                
            public string passwordHash { get; set; }
            public UserRole role { get; set; }
            public DateTime createdAt { get; set; }
        }

        public class Activity
        {
            public string activityId { get; set; }             
            public ActivityType activityType { get; set; }
            public string title { get; set; }

            // destinatarios
            public bool forAll { get; set; }
            public int? filialNumber { get; set; }             

            // fechas (publicación / vigencia)
            public DateTime publishStart { get; set; }
            public DateTime publishEnd { get; set; }          

            // reunión
            public string meetingUrl { get; set; }
            public string meetingAgenda { get; set; }

            // social
            public string place { get; set; }
            public DateTime? eventDate { get; set; }
            public string requirements { get; set; }

            // recordatorio
            public string reminderText { get; set; }

            public DateTime createdAt { get; set; }
            public DateTime updatedAt { get; set; }
        }

        // DTO para recibir desde JS para evitar problemas de DateTime
        public class RegisterDto
        {
            public string idType { get; set; }
            public string idNumber { get; set; }
            public string firstName { get; set; }
            public string lastName { get; set; }
            public string birthDate { get; set; }// yyyy-MM-dd
            public int filialNumber { get; set; }
            public bool hasConstruction { get; set; }
            public string email { get; set; }
            public string password { get; set; }
        }

        public class LoginDto
        {
            public string email { get; set; }
            public string password { get; set; }
        }

        public class ActivityDto
        {
            public string activityId { get; set; }// vacío para crear
            public int activityType { get; set; }// 1,2,3
            public string title { get; set; }

            public bool forAll { get; set; }
            public int? filialNumber { get; set; }

            public string publishStart { get; set; }// yyyy-MM-ddTHH:mm
            public string publishEnd { get; set; }// yyyy-MM-ddTHH:mm

            // reuniónes
            public string meetingUrl { get; set; }
            public string meetingAgenda { get; set; }

            // social
            public string place { get; set; }
            public string eventDate { get; set; }// yyyy-MM-dd 
            public string requirements { get; set; }

            // recordatorio
            public string reminderText { get; set; }
        }

        public class ApiResponse
        {
            public bool ok { get; set; }
            public string message { get; set; }
            public object data { get; set; }

            public static ApiResponse Ok(string message, object data = null)
            {
                return new ApiResponse { ok = true, message = message, data = data };
            }

            public static ApiResponse Fail(string message)
            {
                return new ApiResponse { ok = false, message = message, data = null };
            }
        }

    }
}