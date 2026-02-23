<%@ Page Title="Principal" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Principal.aspx.cs" Inherits="Tarea1.Principal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card" style="max-width:980px;">
    <div class="h1">Panel principal</div>
    <p class="small" style="margin-top:6px;">
      Accede a las opciones disponibles según tu rol en el Condominio Eucalipto CR.
    </p>

    <div class="card" style="padding:12px; margin-top:12px;">
      <div class="h2" style="margin-bottom:6px;">Tu sesión</div>
      <asp:Label ID="lblWelcome" runat="server" CssClass="small" />
    </div>

    <div class="grid" style="margin-top:12px;">

      <asp:Panel ID="pnlAdmin" runat="server" Visible="false">
        <div class="card" style="padding:12px;">
          <div class="h2">Opciones de administrador</div>
          <p class="small" style="margin-top:6px;">
            Crea, edita y elimina actividades/mensajes. Define destinatarios (Todos o por filial) y vigencia por fechas.
          </p>

          <div class="row" style="margin-top:10px; gap:10px; flex-wrap:wrap;">
            <a class="btn btn-primary" href="GestionMensajes.aspx">Gestión de mensajes</a>
            <a class="btn btn-ghost" href="Default.aspx">Volver a Inicio</a>
          </div>
        </div>
      </asp:Panel>

      <asp:Panel ID="pnlUser" runat="server" Visible="false">
        <div class="card" style="padding:12px;">
          <div class="h2">Opciones de condómino</div>
          <p class="small" style="margin-top:6px;">
            Consulta actividades vigentes (para Todos o asignadas a tu filial) y revisa el detalle de cada publicación.
          </p>

          <div class="row" style="margin-top:10px; gap:10px; flex-wrap:wrap;">
            <a class="btn btn-primary" href="Actividades.aspx">Actividades del condominio</a>
            <a class="btn btn-ghost" href="Default.aspx">Volver a Inicio</a>
          </div>
        </div>
      </asp:Panel>

    </div>

  </div>

</asp:Content>
