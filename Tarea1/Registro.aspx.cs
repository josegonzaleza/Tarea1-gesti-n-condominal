using System;
using System.Linq;
using Tarea1.AppCode;
using static Tarea1.AppCode.Models;

namespace Tarea1
{
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataStore.EnsureSeed();

            if (!IsPostBack)
            {
                BindUsers();
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;

            var idType = (ddlIdType.SelectedValue ?? "").Trim();
            var idNumber = (txtIdNumber.Text ?? "").Trim();
            var firstName = (txtFirstName.Text ?? "").Trim();
            var lastName = (txtLastName.Text ?? "").Trim();
            var birthRaw = (txtBirthDate.Text ?? "").Trim();
            var filialRaw = (txtFilialNumber.Text ?? "").Trim();
            var hasConstruction = (ddlHasConstruction.SelectedValue == "true");
            var email = (txtEmail.Text ?? "").Trim().ToLowerInvariant();
            var password = txtPassword.Text ?? "";
            var confirm = txtConfirm.Text ?? "";
            var terms = chkTerms.Checked;

            if (string.IsNullOrWhiteSpace(idType)) { ShowError("Tipo de identificación es requerido."); return; }
            if (string.IsNullOrWhiteSpace(idNumber)) { ShowError("Identificación es requerida."); return; }
            // validar que la identificación tenga al menos 9 dígitos
            var idDigits = new string(idNumber.Where(char.IsDigit).ToArray());
            if (idDigits.Length < 9) { ShowError("La identificación debe tener al menos 9 dígitos."); return; }
            if (string.IsNullOrWhiteSpace(firstName)) { ShowError("Nombre es requerido."); return; }
            if (string.IsNullOrWhiteSpace(lastName)) { ShowError("Apellidos son requeridos."); return; }
            if (!SecurityHelper.IsValidEmail(email)) { ShowError("Correo inválido."); return; }
            if (string.IsNullOrWhiteSpace(password) || password.Length < 6) { ShowError("La contraseña debe tener al menos 6 caracteres."); return; }
            if (password != confirm) { ShowError("Las contraseñas no coinciden."); return; }
            if (!terms) { ShowError("Debe aceptar términos y condiciones."); return; }

            DateTime birthDate;
            if (!DateTime.TryParse(birthRaw, out birthDate)) { ShowError("Fecha de nacimiento inválida."); return; }

            int filialNumber;
            if (!int.TryParse(filialRaw, out filialNumber) || filialNumber < 0) { ShowError("Número de filial inválido."); return; }

            if (DataStore.EmailExists(email))
            {
                ShowError("Ya existe un usuario con ese correo.");
                return;
            }

            var user = new User
            {
                userId = Guid.NewGuid().ToString("N"),
                idType = idType,
                idNumber = idNumber,
                firstName = firstName,
                lastName = lastName,
                birthDate = birthDate,
                filialNumber = filialNumber,
                hasConstruction = hasConstruction,
                email = email,
                passwordHash = SecurityHelper.HashPassword(password),
                role = UserRole.Condominio,
                createdAt = DateTime.Now
            };

            DataStore.AddUser(user);

            ShowOk("Registro exitoso. Ya puedes iniciar sesión.");
            ClearForm();
            BindUsers();

            upUsers.Update();     // refresca la tabla sin recargar
            upRegistro.Update();  // refresca el mensaje / formulario
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            pnlMsg.Visible = false;
            ClearForm();
            upRegistro.Update();
        }

        private void BindUsers()
        {
            var data = DataStore.GetUsers()
                .Select(u => new
                {
                    u.email,
                    fullName = u.firstName + " " + u.lastName,
                    u.filialNumber,
                    role = u.role.ToString()
                })
                .ToList();

            gvUsers.DataSource = data;
            gvUsers.DataBind();
        }

        private void ClearForm()
        {
            ddlIdType.SelectedIndex = 0;
            txtIdNumber.Text = "";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtBirthDate.Text = "";
            txtFilialNumber.Text = "";
            ddlHasConstruction.SelectedValue = "true";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirm.Text = "";
            chkTerms.Checked = false;
        }

        private void ShowError(string message)
        {
            pnlMsg.Visible = true;
            pnlMsg.CssClass = "msg msg-error";
            lblMsg.Text = message;
        }

        private void ShowOk(string message)
        {
            pnlMsg.Visible = true;
            pnlMsg.CssClass = "msg msg-ok";
            lblMsg.Text = message;
        }
    }
}