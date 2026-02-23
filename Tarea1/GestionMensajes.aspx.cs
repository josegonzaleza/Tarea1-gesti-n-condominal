using System;
using System.Linq;
using System.Web.UI;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class GestionMensajes : Page
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

            if (!IsPostBack)
            {
                ResetToNew(runClientScripts: false);
                BindGrid();
            }
        }

        protected void ddlActivityType_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;

            TogglePanels();
            upForm.Update();

            RunClientResetScripts();
        }

        protected void ddlAudience_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;

            ToggleFilial();
            upForm.Update();

            RunClientResetScripts();
        }

        protected void ddlTypeFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;

            BindGrid();
            upGrid.Update();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;
            ResetToNew(runClientScripts: true);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;
            DataStore.EnsureSeed();

            var now = DateTime.Now;

            var activityId = (hfActivityId.Value ?? "").Trim();
            var type = (ActivityType)int.Parse(ddlActivityType.SelectedValue);

            var title = (txtTitle.Text ?? "").Trim();
            if (string.IsNullOrWhiteSpace(title))
            {
                ShowError("Título requerido.");
                return;
            }

            var audience = ddlAudience.SelectedValue;
            var forAll = (audience == "all");

            int filialParsed;
            int? filialNumber = null;
            if (!forAll)
            {
                if (!int.TryParse((txtFilialNumber.Text ?? "").Trim(), out filialParsed) || filialParsed < 0)
                {
                    ShowError("Filial requerida (número válido) si seleccionas 'Por filial'.");
                    return;
                }
                filialNumber = filialParsed;
            }

            DateTime publishStart, publishEnd;
            if (!TryParseDateTimeLocal(txtPublishStart.Text, out publishStart))
            {
                ShowError("Inicio de publicación inválido.");
                return;
            }
            if (!TryParseDateTimeLocal(txtPublishEnd.Text, out publishEnd))
            {
                ShowError("Fin de publicación inválido.");
                return;
            }
            if (publishStart >= publishEnd)
            {
                ShowError("La fecha de inicio debe ser menor que la fecha de fin.");
                return;
            }

            Activity existing = null;
            if (!string.IsNullOrWhiteSpace(activityId))
            {
                existing = DataStore.FindActivityById(activityId);
                if (existing == null)
                {
                    ShowError("No existe la actividad a editar.");
                    return;
                }

                if (now >= existing.publishStart)
                {
                    ShowError("No se puede editar una actividad cuando la fecha de inicio ya pasó.");
                    return;
                }
            }

            var meetingUrl = (txtMeetingUrl.Text ?? "").Trim();
            var meetingAgenda = (txtMeetingAgenda.Text ?? "").Trim();

            var place = (txtPlace.Text ?? "").Trim();
            var eventDateRaw = (txtEventDate.Text ?? "").Trim();
            var requirements = (txtRequirements.Text ?? "").Trim();

            var reminderText = (txtReminderText.Text ?? "").Trim();

            if (type == ActivityType.Reunion)
            {
                if (!string.IsNullOrWhiteSpace(meetingUrl) && !SecurityHelper.IsValidUrl(meetingUrl))
                {
                    ShowError("URL de reunión inválida (http/https).");
                    return;
                }
                if (string.IsNullOrWhiteSpace(meetingAgenda))
                {
                    ShowError("Agenda requerida para reunión.");
                    return;
                }
            }
            else if (type == ActivityType.Social)
            {
                if (string.IsNullOrWhiteSpace(place))
                {
                    ShowError("Lugar requerido para actividad social.");
                    return;
                }

                DateTime ev;
                if (!DateTime.TryParse(eventDateRaw, out ev))
                {
                    ShowError("Fecha del evento inválida.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(requirements))
                {
                    ShowError("Requisitos requeridos para actividad social.");
                    return;
                }
            }
            else
            {
                if (string.IsNullOrWhiteSpace(reminderText))
                {
                    ShowError("Texto requerido para recordatorio.");
                    return;
                }
            }

            var activity = new Activity
            {
                activityId = string.IsNullOrWhiteSpace(activityId) ? Guid.NewGuid().ToString("N") : activityId,
                activityType = type,
                title = title,
                forAll = forAll,
                filialNumber = forAll ? (int?)null : filialNumber,
                publishStart = publishStart,
                publishEnd = publishEnd,

                meetingUrl = (type == ActivityType.Reunion) ? meetingUrl : null,
                meetingAgenda = (type == ActivityType.Reunion) ? meetingAgenda : null,

                place = (type == ActivityType.Social) ? place : null,
                eventDate = (type == ActivityType.Social && !string.IsNullOrWhiteSpace(eventDateRaw)) ? (DateTime?)DateTime.Parse(eventDateRaw) : null,
                requirements = (type == ActivityType.Social) ? requirements : null,

                reminderText = (type == ActivityType.Recordatorio) ? reminderText : null,

                createdAt = (existing == null) ? now : existing.createdAt,
                updatedAt = now
            };

            DataStore.UpsertActivity(activity);

            ShowOk(existing == null ? "Actividad creada." : "Actividad actualizada.");

            
            BindGrid();
            upGrid.Update();
            ResetToNew(runClientScripts: true);
        }

        protected void gvActivities_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            pnlMsg.Visible = false;

            var activityId = (e.CommandArgument ?? "").ToString();
            if (string.IsNullOrWhiteSpace(activityId)) return;

            DataStore.EnsureSeed();

            if (e.CommandName == "editItem")
            {
                var a = DataStore.FindActivityById(activityId);
                if (a == null)
                {
                    ShowError("Actividad no encontrada.");
                    return;
                }

                if (DateTime.Now >= a.publishStart)
                {
                    ShowError("No se puede editar una actividad cuando la fecha de inicio ya pasó.");
                    return;
                }

                FillForm(a);
                TogglePanels();
                ToggleFilial();

                upForm.Update();
                RunClientResetScripts();
                return;
            }

            if (e.CommandName == "deleteItem")
            {
                string message;
                var ok = DataStore.DeleteActivity(activityId, out message);
                if (!ok) ShowError(message);
                else ShowOk(message);

                BindGrid();
                upGrid.Update();

                if (string.Equals((hfActivityId.Value ?? "").Trim(), activityId, StringComparison.OrdinalIgnoreCase))
                {
                    ResetToNew(runClientScripts: true);
                }
                else
                {
                    upForm.Update();
                    RunClientResetScripts();
                }
            }
        }

        private void BindGrid()
        {
            int filter = int.Parse(ddlTypeFilter.SelectedValue);
            int? typeFilter = (filter == 0) ? (int?)null : filter;

            var list = DataStore.GetActivitiesForAdmin(typeFilter)
                .Select(a => new
                {
                    a.activityId,
                    title = a.title,
                    typeText =
                        a.activityType == ActivityType.Reunion ? "Reunión" :
                        a.activityType == ActivityType.Social ? "Actividad social" : "Recordatorio",
                    publishRange = $"{a.publishStart:yyyy-MM-dd HH:mm} → {a.publishEnd:yyyy-MM-dd HH:mm}",
                    audienceText = a.forAll ? "Todos" : ("Filial " + (a.filialNumber.HasValue ? a.filialNumber.Value.ToString() : ""))
                })
                .ToList();

            gvActivities.DataSource = list;
            gvActivities.DataBind();
        }

        private void TogglePanels()
        {
            var type = int.Parse(ddlActivityType.SelectedValue);
            pnlMeeting.Visible = type == 1;
            pnlSocial.Visible = type == 2;
            pnlReminder.Visible = type == 3;
        }

        private void ToggleFilial()
        {
            var isFilial = ddlAudience.SelectedValue == "filial";
            txtFilialNumber.Enabled = isFilial;
            if (!isFilial) txtFilialNumber.Text = "";
        }

        private void InitDefaultsIfEmpty()
        {
            if (string.IsNullOrWhiteSpace(txtPublishStart.Text) || string.IsNullOrWhiteSpace(txtPublishEnd.Text))
            {
                var now = DateTime.Now;
                txtPublishStart.Text = ToDateTimeLocal(now);
                txtPublishEnd.Text = ToDateTimeLocal(now.AddHours(1));
            }
        }

        private void ClearForm()
        {
            hfActivityId.Value = "";
            ddlActivityType.SelectedValue = "1";
            txtTitle.Text = "";
            ddlAudience.SelectedValue = "all";
            txtFilialNumber.Text = "";

            txtPublishStart.Text = "";
            txtPublishEnd.Text = "";

            txtMeetingUrl.Text = "";
            txtMeetingAgenda.Text = "";

            txtPlace.Text = "";
            txtEventDate.Text = "";
            txtRequirements.Text = "";

            txtReminderText.Text = "";
        }

        private void ResetToNew(bool runClientScripts)
        {
            ClearForm();
            InitDefaultsIfEmpty();
            TogglePanels();
            ToggleFilial();

            upForm.Update();

            if (runClientScripts)
                RunClientResetScripts();
        }

        private void FillForm(Activity a)
        {
            hfActivityId.Value = a.activityId;

            ddlActivityType.SelectedValue = ((int)a.activityType).ToString();
            txtTitle.Text = a.title ?? "";

            ddlAudience.SelectedValue = a.forAll ? "all" : "filial";
            txtFilialNumber.Text = a.filialNumber.HasValue ? a.filialNumber.Value.ToString() : "";

            txtPublishStart.Text = ToDateTimeLocal(a.publishStart);
            txtPublishEnd.Text = ToDateTimeLocal(a.publishEnd);

            txtMeetingUrl.Text = a.meetingUrl ?? "";
            txtMeetingAgenda.Text = a.meetingAgenda ?? "";

            txtPlace.Text = a.place ?? "";
            txtEventDate.Text = a.eventDate.HasValue ? a.eventDate.Value.ToString("yyyy-MM-dd") : "";
            txtRequirements.Text = a.requirements ?? "";

            txtReminderText.Text = a.reminderText ?? "";
        }

        private bool TryParseDateTimeLocal(string input, out DateTime dt)
        {
            return DateTime.TryParse(input, out dt);
        }

        private string ToDateTimeLocal(DateTime dt)
        {
            return dt.ToString("yyyy-MM-ddTHH:mm");
        }

        private void ShowError(string msg)
        {
            pnlMsg.Visible = true;
            pnlMsg.CssClass = "msg msg-error";
            lblMsg.Text = msg;
        }

        private void ShowOk(string msg)
        {
            pnlMsg.Visible = true;
            pnlMsg.CssClass = "msg msg-ok";
            lblMsg.Text = msg;
        }

        private void RunClientResetScripts()
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "clientReset_" + Guid.NewGuid().ToString("N"),
                "if(window.clearClientMsg) clearClientMsg(); if(window.initAdminForm) initAdminForm();", true);
        }
    }
}