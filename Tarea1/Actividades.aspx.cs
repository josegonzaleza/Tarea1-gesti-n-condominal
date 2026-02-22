using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class Actividades : System.Web.UI.Page
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
            if (user.role != UserRole.Condominio)
            {
                Response.Redirect("~/Principal.aspx");
                return;
            }

            lblInfo.Text = $"Usuario: {user.firstName} {user.lastName} | Filial: {user.filialNumber}";
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse UserGetBoard(int typeFilter)
        {
            DataStore.EnsureSeed();

            // obtener usuario de sesión (en WebMethod: HttpContext.Current.Session)
            var user = System.Web.HttpContext.Current.Session["currentUser"] as User;
            if (user == null) return ApiResponse.Fail("Sesión expirada. Vuelve a iniciar sesión.");

            var now = DateTime.Now;

            var list = DataStore.GetActivitiesForUser(user, typeFilter == 0 ? (int?)null : typeFilter)
                .Select(a => new
                {
                    a.activityId,
                    activityType = (int)a.activityType,
                    a.title,
                    publishStart = a.publishStart.ToString("yyyy-MM-dd HH:mm"),
                    publishEnd = a.publishEnd.ToString("yyyy-MM-dd HH:mm"),
                    status = GetStatus(now, a.publishStart, a.publishEnd)
                })
                .ToList();

            return ApiResponse.Ok("OK", list);
        }

        private static string GetStatus(DateTime now, DateTime start, DateTime end)
        {
            if (now < start) return "Próxima";
            if (now >= start && now <= end) return "En curso";
            return "Finalizada";
        }
    }
}