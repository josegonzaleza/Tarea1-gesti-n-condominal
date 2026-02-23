<%@ Page Title="Actividades" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Actividades.aspx.cs" Inherits="Tarea1.Actividades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card">
    <div class="h1">Actividades del condominio</div>
    <asp:Label ID="lblInfo" runat="server" CssClass="small" />

    <div class="row" style="margin-top:10px; justify-content:space-between;">
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

    <div id="clientMsg" class="msg msg-error" style="display:none;"></div>

    <asp:UpdatePanel ID="upBoard" runat="server" UpdateMode="Conditional">
      <ContentTemplate>

        <asp:Panel ID="pnlMsg" runat="server" CssClass="msg" Visible="false" style="margin-top:10px;">
          <asp:Label ID="lblMsg" runat="server" />
        </asp:Panel>

        <asp:Timer ID="tmRefresh" runat="server" Interval="10000" OnTick="tmRefresh_Tick" />

        <asp:GridView ID="gvBoard" runat="server" CssClass="table" AutoGenerateColumns="false">
          <Columns>
            <asp:TemplateField HeaderText="Título">
              <ItemTemplate>
                <a class="link" href='ActividadDetalle.aspx?id=<%# Eval("activityId") %>'>
                  <%# Eval("title") %>
                </a>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField HeaderText="Tipo" DataField="typeText" />
            <asp:BoundField HeaderText="Publicación" DataField="publishRange" />
            <asp:BoundField HeaderText="Estado" DataField="status" />

            <asp:TemplateField HeaderText="Detalle">
              <ItemTemplate>
                <a class="link" href='ActividadDetalle.aspx?id=<%# Eval("activityId") %>'>Ver</a>
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>
        </asp:GridView>

      </ContentTemplate>

      <Triggers>
        <asp:AsyncPostBackTrigger ControlID="ddlTypeFilter" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="tmRefresh" EventName="Tick" />
      </Triggers>
    </asp:UpdatePanel>

  </div>

  <script>
    (function(){
      var ddl = document.getElementById("<%= ddlTypeFilter.ClientID %>");
          var msgEl = document.getElementById("clientMsg");

          function show(msg) {
              if (!msg) { msgEl.style.display = "none"; msgEl.textContent = ""; }
              else { msgEl.style.display = "block"; msgEl.textContent = msg; }
          }

          ddl.addEventListener("change", function () {
              var v = ddl.value;
              if (v !== "0" && v !== "1" && v !== "2" && v !== "3") show("Filtro inválido.");
              else show("");
          });

          show("");
      })();
  </script>

</asp:Content>