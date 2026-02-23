using System;
using System.Linq;
using System.Web.UI;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class Actividades : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataStore.EnsureSeed();

            var user = Session["currentUser"] as User;
            if (user == null) { Response.Redirect("~/Login.aspx"); return; }
            if (user.role != UserRole.Condominio) { Response.Redirect("~/Principal.aspx"); return; }

            if (!IsPostBack)
            {
                lblInfo.Text = $"Mostrando actividades disponibles para la filial: {user.filialNumber}";
                BindGrid();
            }
        }

        protected void ddlTypeFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;
            BindGrid();
            upBoard.Update();
        }

        protected void tmRefresh_Tick(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;
            BindGrid();
            upBoard.Update();
        }

        private void BindGrid()
        {
            var user = Session["currentUser"] as User;
            if (user == null) { Response.Redirect("~/Login.aspx"); return; }

            int filter = int.Parse(ddlTypeFilter.SelectedValue);
            int? typeFilter = (filter == 0) ? (int?)null : filter;

            var list = DataStore.GetActivitiesForUser(user, typeFilter);
            var now = DateTime.Now;

            var data = list
                .OrderBy(a => a.publishStart)
                .Select(a => new
                {
                    a.activityId,
                    title = a.title,
                    typeText =
                        a.activityType == ActivityType.Reunion ? "Reunión" :
                        a.activityType == ActivityType.Social ? "Actividad social" : "Recordatorio",
                    publishRange = $"{a.publishStart:yyyy-MM-dd HH:mm} → {a.publishEnd:yyyy-MM-dd HH:mm}",
                    status = GetStatus(a, now)
                })
                .ToList();

            gvBoard.DataSource = data;
            gvBoard.DataBind();

            pnlMsg.Visible = false;
        }

        private string GetStatus(Activity a, DateTime now)
        {
            if (now < a.publishStart) return "Próxima";
            if (now >= a.publishStart && now <= a.publishEnd) return "En curso";
            return "Finalizada";
        }

        private void ShowError(string msg)
        {
            pnlMsg.Visible = true;
            pnlMsg.CssClass = "msg msg-error";
            lblMsg.Text = msg;
        }
    }
}