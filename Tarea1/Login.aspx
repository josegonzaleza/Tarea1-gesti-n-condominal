<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Tarea1.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card" style="max-width:520px;">
    <div class="h1">Iniciar sesión</div>

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

    <p class="small" style="margin-top:10px;">
      Admin de prueba: <b>admin@condominio.com</b> / <b>Admin123!</b>
    </p>
  </div>

</asp:Content>
