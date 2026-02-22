<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Tarea1.Registro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="card">
        <div class="h1">Registro de usuario</div>

        <div class="grid">
            <div class="field">
                <label>Tipo de identificación</label>
                <select id="idType">
                    <option value="">Seleccione...</option>
                    <option value="Fisica">Física</option>
                    <option value="Dimex">DIMEX</option>
                    <option value="Pasaporte">Pasaporte</option>
                </select>
            </div>

            <div class="field">
                <label>Identificación</label>
                <input id="idNumber" type="text" />
            </div>

            <div class="field">
                <label>Nombre</label>
                <input id="firstName" type="text" />
            </div>

            <div class="field">
                <label>Apellidos</label>
                <input id="lastName" type="text" />
            </div>

            <div class="field">
                <label>Fecha de nacimiento</label>
                <input id="birthDate" type="date" />
            </div>

            <div class="field">
                <label>Número de filial</label>
                <input id="filialNumber" type="number" min="0" />
            </div>

            <div class="field">
                <label>Tiene construcción</label>
                <select id="hasConstruction">
                    <option value="true">Sí</option>
                    <option value="false">No</option>
                </select>
            </div>

            <div class="field">
                <label>Correo (usuario)</label>
                <input id="email" type="email" />
            </div>

            <div class="field">
                <label>Contraseña</label>
                <input id="password" type="password" />
            </div>

            <div class="field">
                <label>Confirmar contraseña</label>
                <input id="confirmPassword" type="password" />
            </div>
        </div>

        <div class="row" style="margin-top:10px;">
            <label class="small">
                <input id="terms" type="checkbox" />
                Acepto términos y condiciones
            </label>
        </div>

        <div class="row" style="margin-top:12px;">
            <button id="btnRegister" class="btn btn-primary" type="button" disabled>Registrar</button>
            <button id="btnClear" class="btn btn-ghost" type="button">Limpiar</button>
        </div>

        <div id="msgRegister" class="msg" style="display:none;"></div>
    </div>

    <div class="card">
        <div class="h2">Usuarios registrados</div>
        <table class="table" id="tblUsers">
            <thead>
                <tr>
                    <th>Correo</th>
                    <th>Nombre</th>
                    <th>Filial</th>
                    <th>Rol</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

<script>
$(function(){

  function validateForm(){
    clearMessage("msgRegister");

    var idType = $("#idType").val();
    var idNumber = $("#idNumber").val();
    var firstName = $("#firstName").val();
    var lastName = $("#lastName").val();
    var birthDate = $("#birthDate").val();
    var filialNumber = $("#filialNumber").val();
    var email = $("#email").val();
    var password = $("#password").val();
    var confirmPassword = $("#confirmPassword").val();
    var terms = $("#terms").is(":checked");

    var ok =
      !isEmpty(idType) &&
      !isEmpty(idNumber) &&
      !isEmpty(firstName) &&
      !isEmpty(lastName) &&
      !isEmpty(birthDate) &&
      !isEmpty(filialNumber) &&
      isValidEmail(email) &&
      !isEmpty(password) &&
      password === confirmPassword &&
      terms;

    $("#btnRegister").prop("disabled", !ok);
    return ok;
  }

  function renderUsers(users){
    var $tbody = $("#tblUsers tbody");
    $tbody.empty();

    users.forEach(function(u){
      var tr = $("<tr/>");
      tr.append($("<td/>").text(u.email));
      tr.append($("<td/>").text(u.firstName + " " + u.lastName));
      tr.append($("<td/>").text(u.filialNumber));
      tr.append($("<td/>").text(u.role));
      $tbody.append(tr);
    });
  }

 function loadUsers() {
  $.ajax({
    type: "POST",
    url: "Registro.aspx/GetUsers",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: "{}",
    success: function (res) {
      // En ASP.NET WebForms, el objeto real viene en res.d
      var r = res.d;
      if (r && r.ok) {
        renderUsers(r.data || []);
      } else {
        setMessage("msgRegister", (r && r.message) ? r.message : "Error al cargar usuarios.", false);
      }
    },
    error: function (xhr) {
      // Muestra detalle real
      setMessage("msgRegister", "Error Ajax GetUsers: " + xhr.status + " " + xhr.statusText, false);
      console.log(xhr.responseText);
    }
  });
}

  $("#idType, #idNumber, #firstName, #lastName, #birthDate, #filialNumber, #hasConstruction, #email, #password, #confirmPassword, #terms")
    .on("input change", validateForm);

  $("#btnClear").on("click", function(){
    $("#idType").val("");
    $("#idNumber").val("");
    $("#firstName").val("");
    $("#lastName").val("");
    $("#birthDate").val("");
    $("#filialNumber").val("");
    $("#hasConstruction").val("true");
    $("#email").val("");
    $("#password").val("");
    $("#confirmPassword").val("");
    $("#terms").prop("checked", false);
    clearMessage("msgRegister");
    validateForm();
  });

  $("#btnRegister").on("click", function () {
  if (!validateForm()) {
    setMessage("msgRegister", "Revise los campos. Hay información inválida o incompleta.", false);
    return;
  }

  var dto = {
    idType: $("#idType").val(),
    idNumber: $("#idNumber").val(),
    firstName: $("#firstName").val(),
    lastName: $("#lastName").val(),
    birthDate: $("#birthDate").val(),
    filialNumber: parseInt($("#filialNumber").val(), 10),
    hasConstruction: ($("#hasConstruction").val() === "true"),
    email: $("#email").val(),
    password: $("#password").val()
  };

  registerUser(dto);
});

    function registerUser(dto) {
  $.ajax({
    type: "POST",
    url: "Registro.aspx/RegisterUser",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    data: JSON.stringify({ dto: dto }),
    success: function (res) {
      var r = res.d;
      if (r && r.ok) {
        setMessage("msgRegister", r.message, true);
        loadUsers();
        $("#btnClear").click();
      } else {
        setMessage("msgRegister", (r && r.message) ? r.message : "Error al registrar.", false);
      }
    },
    error: function (xhr) {
      setMessage("msgRegister", "Error Ajax RegisterUser: " + xhr.status + " " + xhr.statusText, false);
      console.log(xhr.responseText);
    }
  });
}

  //Inicializo usuarios y formulario
  validateForm();
  loadUsers();
});
</script>

</asp:Content>
