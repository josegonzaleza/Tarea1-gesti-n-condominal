<%@ Page Title="Principal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Principal.aspx.cs" Inherits="Tarea1.Principal" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card">
    <div class="h1">Pantalla principal</div>

    <asp:Label ID="lblWelcome" runat="server" CssClass="small" />
    <div style="height:10px;"></div>

    <asp:Panel ID="pnlAdmin" runat="server" Visible="false">
      <div class="h2">Opciones de administrador</div>
      <a class="btn btn-primary" href="GestionMensajes.aspx">Gestión de mensajes</a>
    </asp:Panel>

    <asp:Panel ID="pnlUser" runat="server" Visible="false">
      <div class="h2">Opciones de condómino</div>
      <a class="btn btn-primary" href="Actividades.aspx">Actividades del condominio</a>
    </asp:Panel>
  </div>

</asp:Content>
