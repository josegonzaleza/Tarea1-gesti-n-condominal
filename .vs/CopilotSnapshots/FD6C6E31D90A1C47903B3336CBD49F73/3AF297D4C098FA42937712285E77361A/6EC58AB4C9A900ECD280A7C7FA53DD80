<%@ Page Title="Actividades" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Actividades.aspx.cs" Inherits="Tarea1.Actividades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card">
    <div class="h1">Actividades del condominio</div>
    <asp:Label ID="lblInfo" runat="server" CssClass="small" />

    <div class="row" style="margin-top:10px; justify-content:space-between;">
      <div class="field" style="min-width:240px;">
        <label>Filtro tipo</label>
        <select id="typeFilter">
          <option value="0">Todos</option>
          <option value="1">Reunión</option>
          <option value="2">Actividad social</option>
          <option value="3">Recordatorio</option>
        </select>
      </div>

    </div>

    <div id="msgUser" class="msg" style="display:none;"></div>

    <table class="table" id="tblUserActivities">
      <thead>
        <tr>
          <th>Título</th>
          <th>Tipo</th>
          <th>Publicación</th>
          <th>Estado</th>
          <th>Detalle</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>

<script>
$(function(){

  function renderType(t){
    if(t === 1) return "Reunión";
    if(t === 2) return "Social";
    return "Recordatorio";
  }

  function loadBoard(){
    var filter = parseInt($("#typeFilter").val(), 10);

    PageMethods.UserGetBoard(filter, function(res){
      if(!res || !res.ok){
        setMessage("msgUser", (res && res.message) ? res.message : "Error al cargar actividades.", false);
        return;
      }
      clearMessage("msgUser");

      var list = res.data || [];
      var $tbody = $("#tblUserActivities tbody");
      $tbody.empty();

      list.forEach(function(a){
        var tr = $("<tr/>");
        var link = $('<a class="link"/>').attr("href", "ActividadDetalle.aspx?id=" + encodeURIComponent(a.activityId)).text(a.title);

        tr.append($("<td/>").append(link));
        tr.append($("<td/>").html('<span class="badge">'+renderType(a.activityType)+'</span>'));
        tr.append($("<td/>").text(a.publishStart + " → " + a.publishEnd));
        tr.append($("<td/>").text(a.status));
        tr.append($("<td/>").html('<a class="link" href="ActividadDetalle.aspx?id='+encodeURIComponent(a.activityId)+'">Ver</a>'));

        $tbody.append(tr);
      });
    });
  }

  $("#typeFilter").on("change", loadBoard);

  // inicializacion
  loadBoard();
  setInterval(loadBoard, 10000);
});
</script>

</asp:Content>
