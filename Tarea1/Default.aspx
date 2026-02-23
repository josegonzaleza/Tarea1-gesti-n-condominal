<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="Tarea1._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <div class="card" style="max-width:980px;">
    <div class="h1">Condominio Eucalipto CR</div>
    <p class="small" style="margin-top:6px;">
      Plataforma para registro, autenticación y consulta de actividades del condominio.
    </p>

    <div class="row" style="margin-top:12px; gap:10px; flex-wrap:wrap;">
      <a class="btn btn-primary" href="Registro.aspx">Registrarse</a>
      <a class="btn btn-ghost" href="Login.aspx">Iniciar sesión</a>
    </div>

    <hr style="border:none;border-top:1px solid #e5e7eb;margin:14px 0;" />

    <div class="grid" style="margin-top:10px;">
      <div class="card" style="padding:12px;">
        <div class="h2">¿Qué puedes hacer?</div>
        <ul class="small" style="margin:8px 0 0 18px;">
          <li>Crear tu cuenta con datos personales y número de filial.</li>
          <li>Iniciar sesión y acceder al módulo según tu rol.</li>
          <li>Visualizar actividades vigentes del condominio.</li>
        </ul>
      </div>

      <div class="card" style="padding:12px;">
        <div class="h2">Roles del sistema</div>
        <ul class="small" style="margin:8px 0 0 18px;">
          <li><b>Administrador:</b> crea, edita y elimina actividades/mensajes.</li>
          <li><b>Condómino:</b> consulta actividades asignadas a “Todos” o a su filial.</li>
        </ul>
      </div>

      <div class="card" style="padding:12px;">
        <div class="h2">¿Cómo empezar?</div>
        <ol class="small" style="margin:8px 0 0 18px;">
          <li>Regístrate con tu correo.</li>
          <li>Inicia sesión.</li>
          <li>Ingresa a Principal para ver tus opciones.</li>
        </ol>
      </div>
    </div>

    <div class="card" style="padding:12px; margin-top:12px;">
      <div class="h2">Acceso de prueba</div>
      <div class="small" style="margin-top:6px;">
        <b>Admin:</b> admin@condominio.com &nbsp;|&nbsp; <b>Clave:</b> Admin123!
      </div>
      <div class="small" style="margin-top:6px;">
        Si eres condómino, debes registrarte con tu número de filial para ver actividades dirigidas a tu filial.
      </div>
    </div>
  </div>

</asp:Content>
