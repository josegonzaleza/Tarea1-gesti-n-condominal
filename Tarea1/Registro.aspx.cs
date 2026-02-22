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
    public partial class Registro : Page
    {
        protected void Page_Load(object sender, EventArgs e) { }
        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse GetUsers()
        {
            DataStore.EnsureSeed();

            var list = DataStore.GetUsers()
                .Select(u => new
                {
                    u.email,
                    u.firstName,
                    u.lastName,
                    u.filialNumber,
                    role = u.role.ToString()
                })
                .ToList();

            return ApiResponse.Ok("OK", list);
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static ApiResponse RegisterUser(RegisterDto dto)
        {
            DataStore.EnsureSeed();

            if (dto == null) return ApiResponse.Fail("Datos inválidos.");

            if (string.IsNullOrWhiteSpace(dto.idType)) return ApiResponse.Fail("Tipo de identificación es requerido.");
            if (string.IsNullOrWhiteSpace(dto.idNumber)) return ApiResponse.Fail("Identificación es requerida.");
            if (string.IsNullOrWhiteSpace(dto.firstName)) return ApiResponse.Fail("Nombre es requerido.");
            if (string.IsNullOrWhiteSpace(dto.lastName)) return ApiResponse.Fail("Apellidos son requeridos.");
            if (!SecurityHelper.IsValidEmail(dto.email)) return ApiResponse.Fail("Correo inválido.");
            if (string.IsNullOrWhiteSpace(dto.password) || dto.password.Length < 6) return ApiResponse.Fail("La contraseña debe tener al menos 6 caracteres.");

            DateTime birth;
            if (!DateTime.TryParse(dto.birthDate, out birth)) return ApiResponse.Fail("Fecha de nacimiento inválida.");

            var email = dto.email.Trim().ToLowerInvariant();
            if (DataStore.EmailExists(email)) return ApiResponse.Fail("Ya existe un usuario registrado con ese correo.");

            var user = new User
            {
                userId = Guid.NewGuid().ToString("N"),
                idType = dto.idType.Trim(),
                idNumber = dto.idNumber.Trim(),
                firstName = dto.firstName.Trim(),
                lastName = dto.lastName.Trim(),
                birthDate = birth,
                filialNumber = dto.filialNumber,
                hasConstruction = dto.hasConstruction,
                email = email,
                passwordHash = SecurityHelper.HashPassword(dto.password),
                role = UserRole.Condominio,
                createdAt = DateTime.Now
            };

            DataStore.AddUser(user);
            return ApiResponse.Ok("Registro exitoso. Ya puedes iniciar sesión.", null);
        }
    }
}