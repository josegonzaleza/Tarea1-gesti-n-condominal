using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class ActividadDetalle : Page
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

            var id = (Request.QueryString["id"] ?? "").Trim();
            if (string.IsNullOrWhiteSpace(id))
            {
                ShowError("No se envió el id de la actividad.");
                return;
            }

            var activity = DataStore.FindActivityById(id);
            if (activity == null)
            {
                ShowError("Actividad no encontrada o ya no está publicada.");
                return;
            }

            // control: condómino solo ve lo suyo
            if (user.role == UserRole.Condominio)
            {
                bool allowed = activity.forAll ||
                               (!activity.forAll && activity.filialNumber.HasValue && activity.filialNumber.Value == user.filialNumber);

                if (!allowed)
                {
                    ShowError("No autorizado para ver esta actividad.");
                    return;
                }
            }

            pnlDetail.Visible = true;
            badgeType.InnerText = activity.activityType.ToString();
            lblTitle.InnerText = activity.title;
            lblDates.InnerText = $"Publicación: {activity.publishStart:yyyy-MM-dd HH:mm} → {activity.publishEnd:yyyy-MM-dd HH:mm}";
            lblAudience.InnerText = activity.forAll ? "Destinatarios: Todos" : $"Destinatarios: Filial {activity.filialNumber}";

            pnlMeeting.Visible = activity.activityType == ActivityType.Reunion;
            pnlSocial.Visible = activity.activityType == ActivityType.Social;
            pnlReminder.Visible = activity.activityType == ActivityType.Recordatorio;

            if (pnlMeeting.Visible)
            {
                lnkMeeting.Text = activity.meetingUrl;
                lnkMeeting.NavigateUrl = activity.meetingUrl;
                litAgenda.Text = Server.HtmlEncode(activity.meetingAgenda).Replace("\n", "<br/>");
            }

            if (pnlSocial.Visible)
            {
                lblPlace.Text = activity.place;
                lblEventDate.Text = activity.eventDate.HasValue ? activity.eventDate.Value.ToString("yyyy-MM-dd") : "";
                litRequirements.Text = Server.HtmlEncode(activity.requirements).Replace("\n", "<br/>");
            }

            if (pnlReminder.Visible)
            {
                litReminder.Text = Server.HtmlEncode(activity.reminderText).Replace("\n", "<br/>");
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            lblError.Text = msg;
            pnlDetail.Visible = false;
        }
    }
}