<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="Tarea1.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card" style="max-width:520px;">
    <div class="h1">Iniciar sesión</div>

    <div id="clientMsg" class="msg msg-error" style="display:none;"></div>

    <asp:UpdatePanel ID="upLogin" runat="server" UpdateMode="Conditional">
      <ContentTemplate>

        <div class="field">
          <label>Correo</label>
          <asp:TextBox ID="txtEmail" runat="server" />
        </div>

        <div class="field" style="margin-top:10px;">
          <label>Contraseña</label>
          <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
        </div>

        <div class="row" style="margin-top:12px;">
          <asp:Button ID="btnLogin" runat="server" Text="Autenticar" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
          <a class="btn btn-ghost" href="Registro.aspx">Registrarse</a>
        </div>

        <asp:Panel ID="pnlMsg" runat="server" CssClass="msg msg-error" Visible="false" style="margin-top:10px;">
          <asp:Label ID="lblMsg" runat="server" />
        </asp:Panel>

        

      </ContentTemplate>

      <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnLogin" EventName="Click" />
      </Triggers>
    </asp:UpdatePanel>
  </div>

  <script>
    (function () {
      function isEmpty(v) { return !v || String(v).trim() === ""; }
      function isValidEmail(v) {
        return /^[A-Za-z0-9._+\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-.]+$/.test(String(v || "").trim());
      }

      var emailEl = document.getElementById("<%= txtEmail.ClientID %>");
      var passEl = document.getElementById("<%= txtPassword.ClientID %>");
      var btnEl = document.getElementById("<%= btnLogin.ClientID %>");
      var msgEl = document.getElementById("clientMsg");

      function show(msg) {
        if (!msg) { msgEl.style.display = "none"; msgEl.textContent = ""; }
        else { msgEl.style.display = "block"; msgEl.textContent = msg; }
      }

      function validate(showMsg) {
        var email = emailEl.value;
        var pass = passEl.value;

        var msg = "";
        if (isEmpty(email)) msg = "El correo es obligatorio.";
        else if (!isValidEmail(email)) msg = "El correo no tiene un formato válido.";
        else if (isEmpty(pass)) msg = "La contraseña es obligatoria.";

        btnEl.disabled = !!msg;
        if (showMsg) show(msg);
        else if (!msg) show("");
        return !msg;
      }

      document.addEventListener("input", function () { validate(true); }, true);
      document.addEventListener("change", function () { validate(true); }, true);

      btnEl.addEventListener("click", function (e) {
        if (!validate(true)) {
          e.preventDefault();
          e.stopPropagation();
          return false;
        }
        return true;
      });

      validate(false);
    })();
  </script>

</asp:Content>