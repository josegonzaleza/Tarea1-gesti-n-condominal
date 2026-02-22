<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Tarea1.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="card">
        <div class="h1">Registro</div>

        <asp:UpdatePanel ID="upRegistro" runat="server" UpdateMode="Conditional">
            <ContentTemplate>

                <asp:Panel ID="pnlMsg" runat="server" CssClass="msg" Visible="false">
                    <asp:Label ID="lblMsg" runat="server" />
                </asp:Panel>

                <div class="grid">

                    <div class="field">
                        <label>Tipo identificación</label>
                        <asp:DropDownList ID="ddlIdType" runat="server">
                            <asp:ListItem Value="">Seleccione...</asp:ListItem>
                            <asp:ListItem Value="Fisica">Física</asp:ListItem>
                            <asp:ListItem Value="Dimex">DIMEX</asp:ListItem>
                            <asp:ListItem Value="Pasaporte">Pasaporte</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="field">
                        <label>Identificación</label>
                        <asp:TextBox ID="txtIdNumber" runat="server" />
                    </div>

                    <div class="field">
                        <label>Nombre</label>
                        <asp:TextBox ID="txtFirstName" runat="server" />
                    </div>

                    <div class="field">
                        <label>Apellidos</label>
                        <asp:TextBox ID="txtLastName" runat="server" />
                    </div>

                    <div class="field">
                        <label>Fecha nacimiento</label>
                        <asp:TextBox ID="txtBirthDate" runat="server" TextMode="Date" />
                    </div>

                    <div class="field">
                        <label>Número filial</label>
                        <asp:TextBox ID="txtFilialNumber" runat="server" TextMode="Number" />
                    </div>

                    <div class="field">
                        <label>Tiene construcción</label>
                        <asp:DropDownList ID="ddlHasConstruction" runat="server">
                            <asp:ListItem Value="true">Sí</asp:ListItem>
                            <asp:ListItem Value="false">No</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="field">
                        <label>Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
                    </div>

                    <div class="field">
                        <label>Contraseña</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                    </div>

                    <div class="field">
                        <label>Confirmar</label>
                        <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" />
                    </div>

                </div>

                <div class="row" style="margin-top:10px;">
                    <asp:CheckBox ID="chkTerms" runat="server" Text=" Acepto términos y condiciones" />
                </div>

                <div class="row" style="margin-top:12px;">
                    <asp:Button ID="btnRegister" runat="server" Text="Registrar"
                        CssClass="btn btn-primary" OnClick="btnRegister_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Limpiar"
                        CssClass="btn btn-ghost" OnClick="btnClear_Click" CausesValidation="false" />
                </div>

            </ContentTemplate>

            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnRegister" EventName="Click" />
                <asp:AsyncPostBackTrigger ControlID="btnClear" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

    <div class="card">
        <div class="h2">Usuarios</div>

        <asp:UpdatePanel ID="upUsers" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:GridView ID="gvUsers" runat="server" CssClass="table" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField HeaderText="Correo" DataField="email" />
                        <asp:BoundField HeaderText="Nombre" DataField="fullName" />
                        <asp:BoundField HeaderText="Filial" DataField="filialNumber" />
                        <asp:BoundField HeaderText="Rol" DataField="role" />
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <!-- Validación cliente simple (no depende de WebMethods) -->
    <script>
      (function(){
        function isEmpty(v){ return !v || String(v).trim()===""; }
        function isValidEmail(v){ return /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/i.test(String(v||"").trim()); }

        function validateForm(){
          var idType = document.getElementById("<%= ddlIdType.ClientID %>").value;
          var idNumber = document.getElementById("<%= txtIdNumber.ClientID %>").value;
          var firstName = document.getElementById("<%= txtFirstName.ClientID %>").value;
          var lastName = document.getElementById("<%= txtLastName.ClientID %>").value;
          var birthDate = document.getElementById("<%= txtBirthDate.ClientID %>").value;
          var filial = document.getElementById("<%= txtFilialNumber.ClientID %>").value;
          var email = document.getElementById("<%= txtEmail.ClientID %>").value;
          var pass = document.getElementById("<%= txtPassword.ClientID %>").value;
          var conf = document.getElementById("<%= txtConfirm.ClientID %>").value;
          var terms = document.getElementById("<%= chkTerms.ClientID %>").checked;

          var ok = !isEmpty(idType) && !isEmpty(idNumber) && !isEmpty(firstName) && !isEmpty(lastName) &&
                   !isEmpty(birthDate) && !isEmpty(filial) && isValidEmail(email) &&
                   !isEmpty(pass) && pass.length >= 6 && pass === conf && terms;

          document.getElementById("<%= btnRegister.ClientID %>").disabled = !ok;
        }

        document.addEventListener("input", validateForm, true);
        document.addEventListener("change", validateForm, true);
        validateForm();
      })();
    </script>

</asp:Content>
