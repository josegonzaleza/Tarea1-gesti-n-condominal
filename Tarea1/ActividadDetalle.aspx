<%@ Page Title="Detalle" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ActividadDetalle.aspx.cs" Inherits="Tarea1.ActividadDetalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card" style="max-width:900px;">
    <div class="row" style="justify-content:space-between; align-items:flex-start;">
      <div>
        <div class="h1" style="margin-bottom:6px;">Detalle de actividad</div>

        <div class="row" style="gap:8px; align-items:center; flex-wrap:wrap;">
          <span class="badge" id="badgeType" runat="server"></span>
          <span class="badge" id="badgeStatus" runat="server"></span>
          <span class="small" id="lblAudience" runat="server"></span>
        </div>
      </div>

      <div>
        <a class="btn btn-ghost" href="Actividades.aspx">Volver</a>
      </div>
    </div>

    <asp:Panel ID="pnlError" runat="server" CssClass="msg msg-error" Visible="false" style="margin-top:12px;">
      <asp:Label ID="lblError" runat="server" />
    </asp:Panel>

    <asp:Panel ID="pnlDetail" runat="server" Visible="false">

      <div style="margin-top:12px;">
        <h2 class="h2" id="lblTitle" runat="server" style="margin:0;"></h2>
        <div class="small" id="lblDates" runat="server" style="margin-top:6px;"></div>
      </div>

      <hr style="border:none;border-top:1px solid #e5e7eb;margin:14px 0;" />

      
      <asp:Panel ID="pnlMeeting" runat="server" Visible="false">
        <div class="h2">Reunión</div>

        <div class="grid" style="margin-top:8px;">
          <div class="field" style="grid-column:1/-1;">
            <label>URL</label>
            <div>
              <asp:HyperLink ID="lnkMeeting" runat="server" CssClass="link" Target="_blank" />
              <asp:Label ID="lblNoUrl" runat="server" CssClass="small" Visible="false" Text="No disponible"></asp:Label>
            </div>
          </div>

          <div class="field" style="grid-column:1/-1;">
            <label>Agenda</label>
            <div class="card" style="padding:12px;">
              <asp:Literal ID="litAgenda" runat="server" />
            </div>
          </div>
        </div>
      </asp:Panel>

      
      <asp:Panel ID="pnlSocial" runat="server" Visible="false">
        <div class="h2">Actividad social</div>

        <div class="grid" style="margin-top:8px;">
          <div class="field">
            <label>Lugar</label>
            <asp:Label ID="lblPlace" runat="server" />
          </div>

          <div class="field">
            <label>Fecha del evento</label>
            <asp:Label ID="lblEventDate" runat="server" />
          </div>

          <div class="field" style="grid-column:1/-1;">
            <label>Requisitos</label>
            <div class="card" style="padding:12px;">
              <asp:Literal ID="litRequirements" runat="server" />
            </div>
          </div>
        </div>
      </asp:Panel>

     
      <asp:Panel ID="pnlReminder" runat="server" Visible="false">
        <div class="h2">Recordatorio</div>
        <div class="card" style="padding:12px; margin-top:8px;">
          <asp:Literal ID="litReminder" runat="server" />
        </div>
      </asp:Panel>

    </asp:Panel>
  </div>

</asp:Content>