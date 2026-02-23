using System;
using System.Web;
using System.Web.UI;
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
            if (user.role != UserRole.Condominio)
            {
                Response.Redirect("~/Principal.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDetail(user);
            }
        }

        private void LoadDetail(User user)
        {
            pnlError.Visible = false;
            pnlDetail.Visible = false;

            var id = (Request.QueryString["id"] ?? "").Trim();
            if (string.IsNullOrWhiteSpace(id))
            {
                ShowError("No se recibió el identificador de la actividad (id).");
                return;
            }

            var a = DataStore.FindActivityById(id);
            if (a == null)
            {
                ShowError("La actividad no existe o fue eliminada.");
                return;
            }

            if (DateTime.Now > a.publishEnd)
            {
                ShowError("La actividad ya venció y no está disponible.");
                return;
            }

            var allowed = a.forAll || (!a.forAll && a.filialNumber.HasValue && a.filialNumber.Value == user.filialNumber);
            if (!allowed)
            {
                ShowError("No tienes permiso para ver esta actividad.");
                return;
            }

            badgeType.InnerText =
                a.activityType == ActivityType.Reunion ? "Reunión" :
                a.activityType == ActivityType.Social ? "Actividad social" : "Recordatorio";

            lblAudience.InnerText = a.forAll
                ? "Destinatarios: Todos"
                : "Destinatarios: Filial " + (a.filialNumber.HasValue ? a.filialNumber.Value.ToString() : "");

            lblTitle.InnerText = a.title ?? "";
            lblDates.InnerText = $"Publicación: {a.publishStart:yyyy-MM-dd HH:mm} → {a.publishEnd:yyyy-MM-dd HH:mm}";

            pnlMeeting.Visible = false;
            pnlSocial.Visible = false;
            pnlReminder.Visible = false;

            if (a.activityType == ActivityType.Reunion)
            {
                pnlMeeting.Visible = true;

                if (!string.IsNullOrWhiteSpace(a.meetingUrl))
                {
                    lnkMeeting.NavigateUrl = a.meetingUrl;
                    lnkMeeting.Text = a.meetingUrl;
                }
                else
                {
                    lnkMeeting.NavigateUrl = "";
                    lnkMeeting.Text = "No disponible";
                }

                litAgenda.Text = ToSafeHtml(a.meetingAgenda);
            }
            else if (a.activityType == ActivityType.Social)
            {
                pnlSocial.Visible = true;

                lblPlace.Text = a.place ?? "";
                lblEventDate.Text = a.eventDate.HasValue ? a.eventDate.Value.ToString("yyyy-MM-dd") : "";
                litRequirements.Text = ToSafeHtml(a.requirements);
            }
            else 
            {
                pnlReminder.Visible = true;
                litReminder.Text = ToSafeHtml(a.reminderText);
            }

            pnlDetail.Visible = true;
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            lblError.Text = msg;
        }

       
        private string ToSafeHtml(string text)
        {
            var safe = HttpUtility.HtmlEncode(text ?? "");
            return safe.Replace("\r\n", "<br/>").Replace("\n", "<br/>");
        }
    }
}