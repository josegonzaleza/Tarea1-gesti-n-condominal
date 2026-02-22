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
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataStore.EnsureSeed();

            var user = Session["currentUser"] as User;

            bool isLoggedIn = user != null;
            lnkPrincipal.Visible = isLoggedIn;
            btnLogout.Visible = isLoggedIn;

            if (!isLoggedIn)
            {
                lnkGestion.Visible = false;
                lnkActividades.Visible = false;
                return;
            }

            if (user.role == UserRole.Admin)
            {
                lnkGestion.Visible = true;
                lnkActividades.Visible = false;
            }
            else
            {
                lnkGestion.Visible = false;
                lnkActividades.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Remove("currentUser");
            Response.Redirect("~/Login.aspx");
        }
    }
}