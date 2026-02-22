<%@ Page Title="Detalle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ActividadDetalle.aspx.cs" Inherits="Tarea1.ActividadDetalle" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card">
    <div class="h1">Detalle de actividad</div>
    <asp:Panel ID="pnlError" runat="server" CssClass="msg msg-error" Visible="false">
      <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlDetail" runat="server" Visible="false">
      <div class="row">
        <span class="badge" id="badgeType" runat="server"></span>
        <span class="small" id="lblAudience" runat="server"></span>
      </div>

      <h2 class="h2" id="lblTitle" runat="server"></h2>
      <div class="small" id="lblDates" runat="server"></div>

      <hr style="border:none;border-top:1px solid #e5e7eb;margin:14px 0;" />

      <asp:Panel ID="pnlMeeting" runat="server" Visible="false">
        <div class="h2">Reunión</div>
        <div><b>URL:</b> <asp:HyperLink ID="lnkMeeting" runat="server" CssClass="link" Target="_blank" /></div>
        <div style="margin-top:8px;"><b>Agenda:</b></div>
        <div class="card" style="padding:12px;">
          <asp:Literal ID="litAgenda" runat="server" />
        </div>
      </asp:Panel>

      <asp:Panel ID="pnlSocial" runat="server" Visible="false">
        <div class="h2">Actividad social</div>
        <div><b>Lugar:</b> <asp:Label ID="lblPlace" runat="server" /></div>
        <div><b>Fecha del evento:</b> <asp:Label ID="lblEventDate" runat="server" /></div>
        <div style="margin-top:8px;"><b>Requisitos:</b></div>
        <div class="card" style="padding:12px;">
          <asp:Literal ID="litRequirements" runat="server" />
        </div>
      </asp:Panel>

      <asp:Panel ID="pnlReminder" runat="server" Visible="false">
        <div class="h2">Recordatorio</div>
        <div class="card" style="padding:12px;">
          <asp:Literal ID="litReminder" runat="server" />
        </div>
      </asp:Panel>

      <div style="margin-top:12px;">
        <a class="btn btn-ghost" href="Actividades.aspx">Volver</a>
      </div>
    </asp:Panel>
  </div>

</asp:Content>