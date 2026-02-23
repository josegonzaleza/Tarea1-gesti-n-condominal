using System;
using System.Web.UI;
using Tarea1.AppCode;

namespace Tarea1
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataStore.EnsureSeed();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;

            var email = (txtEmail.Text ?? "").Trim().ToLowerInvariant();
            var password = txtPassword.Text ?? "";

            if (!SecurityHelper.IsValidEmail(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("El usuario y/o la contraseña son inválidos, intente de nuevo");
                return;
            }

            var user = DataStore.FindUserByEmail(email);
            if (user == null)
            {
                ShowError("El usuario y/o la contraseña son inválidos, intente de nuevo");
                return;
            }

            var passwordHash = SecurityHelper.HashPassword(password);
            if (!string.Equals(passwordHash, user.passwordHash, StringComparison.Ordinal))
            {
                ShowError("El usuario y/o la contraseña son inválidos, intente de nuevo");
                return;
            }

            Session["currentUser"] = user;
            Response.Redirect("~/Principal.aspx");
        }

        private void ShowError(string message)
        {
            pnlMsg.Visible = true;
            lblMsg.Text = message;
        }
    }
}