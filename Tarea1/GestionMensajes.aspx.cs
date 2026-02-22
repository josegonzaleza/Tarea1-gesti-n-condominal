using System;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Services;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class GestionMensajes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataStore.EnsureSeed();

            var user = Session["currentUser"] as User;
            if (user == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            if (user.role != UserRole.Admin)
            {
                Response.Redirect("~/Principal.aspx");
                return;
            }
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse AdminGetActivities(int typeFilter)
        {
            DataStore.EnsureSeed();
            var list = DataStore.GetActivitiesForAdmin(typeFilter == 0 ? (int?)null : typeFilter)
                .Select(a => new
                {
                    a.activityId,
                    activityType = (int)a.activityType,
                    a.title,
                    a.forAll,
                    a.filialNumber,
                    publishStart = a.publishStart.ToString("yyyy-MM-dd HH:mm"),
                    publishEnd = a.publishEnd.ToString("yyyy-MM-dd HH:mm")
                })
                .ToList();

            return ApiResponse.Ok("OK", list);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse AdminGetActivityById(string activityId)
        {
            DataStore.EnsureSeed();
            if (string.IsNullOrWhiteSpace(activityId)) return ApiResponse.Fail("Id inválido.");

            var a = DataStore.FindActivityById(activityId);
            if (a == null) return ApiResponse.Fail("Actividad no encontrada.");

            // para llenar datetime-local
            var data = new
            {
                a.activityId,
                activityType = (int)a.activityType,
                a.title,
                a.forAll,
                a.filialNumber,
                publishStartLocal = a.publishStart.ToString("yyyy-MM-ddTHH:mm"),
                publishEndLocal = a.publishEnd.ToString("yyyy-MM-ddTHH:mm"),

                a.meetingUrl,
                a.meetingAgenda,

                a.place,
                eventDate = a.eventDate.HasValue ? a.eventDate.Value.ToString("yyyy-MM-dd") : "",
                a.requirements,

                a.reminderText
            };

            return ApiResponse.Ok("OK", data);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse AdminSaveActivity(ActivityDto dto)
        {
            DataStore.EnsureSeed();
            if (dto == null) return ApiResponse.Fail("Datos inválidos.");

            // validaciones base
            if (string.IsNullOrWhiteSpace(dto.title)) return ApiResponse.Fail("Título requerido.");

            DateTime publishStart, publishEnd;
            if (!DateTime.TryParse(dto.publishStart, out publishStart)) return ApiResponse.Fail("Inicio de publicación inválido.");
            if (!DateTime.TryParse(dto.publishEnd, out publishEnd)) return ApiResponse.Fail("Fin de publicación inválido.");
            if (publishStart >= publishEnd) return ApiResponse.Fail("La fecha de inicio debe ser menor que la fecha de fin.");

            if (!dto.forAll && (!dto.filialNumber.HasValue || dto.filialNumber.Value < 0))
                return ApiResponse.Fail("Filial inválida.");

            var type = (ActivityType)dto.activityType;

            // Si es edición, regla: NO editar si ya pasó inicio
            Activity existing = null;
            if (!string.IsNullOrWhiteSpace(dto.activityId))
            {
                existing = DataStore.FindActivityById(dto.activityId);
                if (existing == null) return ApiResponse.Fail("No existe la actividad a editar.");

                if (DateTime.Now >= existing.publishStart)
                    return ApiResponse.Fail("No se puede editar una actividad cuando la fecha de inicio ya pasó.");
            }

            // validaciones por tipo
            if (type == ActivityType.Reunion)
            {
                if (string.IsNullOrWhiteSpace(dto.meetingUrl)) return ApiResponse.Fail("URL requerida para reunión.");
                if (string.IsNullOrWhiteSpace(dto.meetingAgenda)) return ApiResponse.Fail("Agenda requerida para reunión.");
            }
            if (type == ActivityType.Social)
            {
                if (string.IsNullOrWhiteSpace(dto.place)) return ApiResponse.Fail("Lugar requerido.");
                if (string.IsNullOrWhiteSpace(dto.eventDate)) return ApiResponse.Fail("Fecha del evento requerida.");

                DateTime ev;
                if (!DateTime.TryParse(dto.eventDate, out ev)) return ApiResponse.Fail("Fecha del evento inválida.");
                if (string.IsNullOrWhiteSpace(dto.requirements)) return ApiResponse.Fail("Requisitos requeridos.");
            }
            if (type == ActivityType.Recordatorio)
            {
                if (string.IsNullOrWhiteSpace(dto.reminderText)) return ApiResponse.Fail("Texto requerido para recordatorio.");
            }

            var activity = new Activity
            {
                activityId = string.IsNullOrWhiteSpace(dto.activityId) ? Guid.NewGuid().ToString("N") : dto.activityId,
                activityType = type,
                title = dto.title.Trim(),
                forAll = dto.forAll,
                filialNumber = dto.forAll ? (int?)null : dto.filialNumber,
                publishStart = publishStart,
                publishEnd = publishEnd,

                meetingUrl = dto.meetingUrl,
                meetingAgenda = dto.meetingAgenda,

                place = dto.place,
                eventDate = string.IsNullOrWhiteSpace(dto.eventDate) ? (DateTime?)null : DateTime.Parse(dto.eventDate),
                requirements = dto.requirements,

                reminderText = dto.reminderText,

                createdAt = existing == null ? DateTime.Now : existing.createdAt,
                updatedAt = DateTime.Now
            };

            DataStore.UpsertActivity(activity);

            var msg = (existing == null) ? "Actividad creada." : "Actividad actualizada.";
            return ApiResponse.Ok(msg, null);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse AdminDeleteActivity(string activityId)
        {
            DataStore.EnsureSeed();

            if (string.IsNullOrWhiteSpace(activityId))
                return ApiResponse.Fail("Id inválido.");

            string message;
            var ok = DataStore.DeleteActivity(activityId, out message);
            return ok ? ApiResponse.Ok(message) : ApiResponse.Fail(message);
        }
    }
}