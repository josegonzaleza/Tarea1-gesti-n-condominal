<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Tarea1._Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card">
        <div class="h1">Bienvenido</div>
        <p class="small">
            Sistema de registro, autenticación y tablero de actividades del condominio.
        </p>
        <div class="row">
            <a class="btn btn-primary" href="Registro.aspx">Registrarse</a>
            <a class="btn btn-ghost" href="Login.aspx">Iniciar sesión</a>
        </div>
    </div>
</asp:Content>
