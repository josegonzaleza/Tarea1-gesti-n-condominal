<%@ Page Title="Gestión" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="GestionMensajes.aspx.cs" Inherits="Tarea1.GestionMensajes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card">
    <div class="h1">Gestión de mensajes / actividades</div>

    <div id="clientMsg" class="msg msg-error" style="display:none;"></div>

    <asp:UpdatePanel ID="upForm" runat="server" UpdateMode="Conditional">
      <ContentTemplate>

        <asp:HiddenField ID="hfActivityId" runat="server" />
>
        <asp:Panel ID="pnlMsg" runat="server" CssClass="msg" Visible="false">
          <asp:Label ID="lblMsg" runat="server" />
        </asp:Panel>

        <div class="grid" style="margin-top:10px;">

          <div class="field">
            <label>Tipo</label>
            <asp:DropDownList ID="ddlActivityType" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlActivityType_SelectedIndexChanged">
              <asp:ListItem Value="1">Reunión</asp:ListItem>
              <asp:ListItem Value="2">Actividad social</asp:ListItem>
              <asp:ListItem Value="3">Recordatorio</asp:ListItem>
            </asp:DropDownList>
          </div>

          <div class="field">
            <label>Título</label>
            <asp:TextBox ID="txtTitle" runat="server" />
          </div>

          <div class="field">
            <label>Destinatarios</label>
            <asp:DropDownList ID="ddlAudience" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlAudience_SelectedIndexChanged">
              <asp:ListItem Value="all">Todos</asp:ListItem>
              <asp:ListItem Value="filial">Por filial</asp:ListItem>
            </asp:DropDownList>
          </div>

          <div class="field">
            <label>Número de filial</label>
            <asp:TextBox ID="txtFilialNumber" runat="server" TextMode="Number" />
          </div>

          <div class="field">
            <label>Inicio de publicación</label>
            <asp:TextBox ID="txtPublishStart" runat="server" TextMode="DateTimeLocal" />
          </div>

          <div class="field">
            <label>Fin de publicación</label>
            <asp:TextBox ID="txtPublishEnd" runat="server" TextMode="DateTimeLocal" />
          </div>

        </div>

        <asp:Panel ID="pnlMeeting" runat="server" CssClass="card" Style="margin-top:12px;">
          <div class="h2">Campos de reunión</div>
          <div class="grid">
            <div class="field">
              <label>URL (virtual) (opcional)</label>
              <asp:TextBox ID="txtMeetingUrl" runat="server" />
            </div>
            <div class="field">
              <label>Agenda</label>
              <asp:TextBox ID="txtMeetingAgenda" runat="server" TextMode="MultiLine" />
            </div>
          </div>
        </asp:Panel>

        <asp:Panel ID="pnlSocial" runat="server" CssClass="card" Style="margin-top:12px;" Visible="false">
          <div class="h2">Campos de actividad social</div>
          <div class="grid">
            <div class="field">
              <label>Lugar</label>
              <asp:TextBox ID="txtPlace" runat="server" />
            </div>
            <div class="field">
              <label>Fecha del evento</label>
              <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" />
            </div>
            <div class="field" style="grid-column:1/-1;">
              <label>Requisitos</label>
              <asp:TextBox ID="txtRequirements" runat="server" TextMode="MultiLine" />
            </div>
          </div>
        </asp:Panel>

        <!-- Panel Recordatorio -->
        <asp:Panel ID="pnlReminder" runat="server" CssClass="card" Style="margin-top:12px;" Visible="false">
          <div class="h2">Campos de recordatorio</div>
          <div class="field">
            <label>Texto</label>
            <asp:TextBox ID="txtReminderText" runat="server" TextMode="MultiLine" />
          </div>
        </asp:Panel>

        <div class="row" style="margin-top:12px;">
          <asp:Button ID="btnSave" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnSave_Click" />
          <asp:Button ID="btnReset" runat="server" Text="Nuevo" CssClass="btn btn-ghost" OnClick="btnReset_Click" CausesValidation="false" />
        </div>

      </ContentTemplate>

      <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ddlActivityType" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="ddlAudience" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnReset" EventName="Click" />
      </Triggers>
    </asp:UpdatePanel>
  </div>

  <div class="card">
    <div class="row" style="justify-content:space-between;">
      <div>
        <div class="h2">Listado</div>
        <div class="small">Editar: solo si aún no inició publicación. Eliminar: solo si no ha vencido.</div>
      </div>

      <div class="field" style="min-width:240px;">
        <label>Filtro tipo</label>
        <asp:DropDownList ID="ddlTypeFilter" runat="server" AutoPostBack="true"
            OnSelectedIndexChanged="ddlTypeFilter_SelectedIndexChanged">
          <asp:ListItem Value="0">Todos</asp:ListItem>
          <asp:ListItem Value="1">Reunión</asp:ListItem>
          <asp:ListItem Value="2">Actividad social</asp:ListItem>
          <asp:ListItem Value="3">Recordatorio</asp:ListItem>
        </asp:DropDownList>
      </div>
    </div>

    <asp:UpdatePanel ID="upGrid" runat="server" UpdateMode="Conditional">
      <ContentTemplate>
        <asp:GridView ID="gvActivities" runat="server" CssClass="table" AutoGenerateColumns="false"
            OnRowCommand="gvActivities_RowCommand">
          <Columns>
            <asp:BoundField HeaderText="Título" DataField="title" />
            <asp:BoundField HeaderText="Tipo" DataField="typeText" />
            <asp:BoundField HeaderText="Publicación" DataField="publishRange" />
            <asp:BoundField HeaderText="Destinatarios" DataField="audienceText" />

            <asp:TemplateField HeaderText="Acciones">
              <ItemTemplate>
                <asp:LinkButton ID="lnkEdit" runat="server" CssClass="link"
                    CommandName="editItem" CommandArgument='<%# Eval("activityId") %>'>Editar</asp:LinkButton>
                &nbsp;|&nbsp;
                <asp:LinkButton ID="lnkDelete" runat="server" CssClass="link"
                    CommandName="deleteItem" CommandArgument='<%# Eval("activityId") %>'
                    OnClientClick="return confirm('¿Eliminar actividad?');">Eliminar</asp:LinkButton>
              </ItemTemplate>
            </asp:TemplateField>

          </Columns>
        </asp:GridView>
      </ContentTemplate>
      <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ddlTypeFilter" EventName="SelectedIndexChanged" />
      </Triggers>
    </asp:UpdatePanel>
  </div>

  <script>

    function clearClientMsg() {
      var msgEl = document.getElementById("clientMsg");
      if (!msgEl) return;
      msgEl.style.display = "none";
      msgEl.textContent = "";
      msgEl.className = "msg msg-error";
    }

    function initAdminForm() {

      function isEmpty(v) { return v === null || v === undefined || String(v).trim() === ""; }
      function toInt(v) { var n = parseInt(v, 10); return isNaN(n) ? null : n; }
      function isValidUrl(u) {
        if (isEmpty(u)) return true;
        try { var x = new URL(u); return x.protocol === "http:" || x.protocol === "https:"; }
        catch (e) { return false; }
      }

      var typeEl = document.getElementById("<%= ddlActivityType.ClientID %>");
      var titleEl = document.getElementById("<%= txtTitle.ClientID %>");
      var audEl = document.getElementById("<%= ddlAudience.ClientID %>");
      var filialEl = document.getElementById("<%= txtFilialNumber.ClientID %>");
      var psEl = document.getElementById("<%= txtPublishStart.ClientID %>");
      var peEl = document.getElementById("<%= txtPublishEnd.ClientID %>");
      var btnEl = document.getElementById("<%= btnSave.ClientID %>");
      var msgEl = document.getElementById("clientMsg");

      var meetUrlEl = document.getElementById("<%= txtMeetingUrl.ClientID %>");
      var meetAgEl = document.getElementById("<%= txtMeetingAgenda.ClientID %>");

      var placeEl = document.getElementById("<%= txtPlace.ClientID %>");
      var eventDateEl = document.getElementById("<%= txtEventDate.ClientID %>");
      var reqEl = document.getElementById("<%= txtRequirements.ClientID %>");

      var remEl = document.getElementById("<%= txtReminderText.ClientID %>");

      if (!typeEl || !titleEl || !audEl || !filialEl || !psEl || !peEl || !btnEl || !msgEl) return;

      function show(msg) {
        if (!msg) { msgEl.style.display = "none"; msgEl.textContent = ""; }
        else { msgEl.style.display = "block"; msgEl.textContent = msg; }
      }

      function validate(showMsg) {
        var t = typeEl.value;
        var title = titleEl.value;
        var aud = audEl.value;
        var filial = filialEl.value;
        var ps = psEl.value;
        var pe = peEl.value;

        var msg = "";

        if (isEmpty(title)) msg = "Título requerido.";
        else if (isEmpty(ps) || isEmpty(pe)) msg = "Fechas de publicación requeridas.";
        else if (ps >= pe) msg = "La fecha de inicio debe ser menor que la fecha de fin.";
        else if (aud === "filial") {
          var f = toInt(filial);
          if (f === null || f < 0) msg = "Filial requerida (número válido) si seleccionas 'Por filial'.";
        }

        if (!msg) {
          if (t === "1") {
            if (!isValidUrl(meetUrlEl.value)) msg = "URL de reunión inválida (http/https).";
            else if (isEmpty(meetAgEl.value)) msg = "Agenda requerida para reunión.";
          } else if (t === "2") {
            if (isEmpty(placeEl.value)) msg = "Lugar requerido para actividad social.";
            else if (isEmpty(eventDateEl.value)) msg = "Fecha del evento requerida para actividad social.";
            else if (isEmpty(reqEl.value)) msg = "Requisitos requeridos para actividad social.";
          } else {
            if (isEmpty(remEl.value)) msg = "Texto requerido para recordatorio.";
          }
        }

        btnEl.disabled = !!msg;
        if (showMsg) show(msg);
        else if (!msg) show("");

        return !msg;
      }

      if (!btnEl.dataset) btnEl.dataset = {};
      if (btnEl.dataset.bound !== "1") {

        var onAnyInput = function () { validate(true); };
        document.addEventListener("input", onAnyInput, true);
        document.addEventListener("change", onAnyInput, true);

        btnEl.addEventListener("click", function (e) {
          if (!validate(true)) {
            e.preventDefault();
            e.stopPropagation();
            return false;
          }
          return true;
        });

        btnEl.dataset.bound = "1";
      }

      validate(false);
    }

    document.addEventListener("DOMContentLoaded", function () {
      initAdminForm();
    });

    if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
      Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        initAdminForm();
      });
    }
  </script>

</asp:Content>