using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class Principal : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var user = Session["currentUser"] as User;
            if (user == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            lblWelcome.Text = $"Bienvenido, {user.firstName} {user.lastName} | Rol: {user.role}";

            pnlAdmin.Visible = user.role == UserRole.Admin;
            pnlUser.Visible = user.role == UserRole.Condominio;
        }
    }
}