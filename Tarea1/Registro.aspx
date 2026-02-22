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
                        <div class="field-error" id="<%= ddlIdType.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Identificación</label>
                        <asp:TextBox ID="txtIdNumber" runat="server" />
                        <div class="field-error" id="<%= txtIdNumber.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Nombre</label>
                        <asp:TextBox ID="txtFirstName" runat="server" />
                        <div class="field-error" id="<%= txtFirstName.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Apellidos</label>
                        <asp:TextBox ID="txtLastName" runat="server" />
                        <div class="field-error" id="<%= txtLastName.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Fecha nacimiento</label>
                        <asp:TextBox ID="txtBirthDate" runat="server" TextMode="Date" />
                        <div class="field-error" id="<%= txtBirthDate.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Número filial</label>
                        <asp:TextBox ID="txtFilialNumber" runat="server" TextMode="Number" />
                        <div class="field-error" id="<%= txtFilialNumber.ClientID %>_err"></div>
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
                        <div class="field-error" id="<%= txtEmail.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Contraseña</label>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                        <div class="field-error" id="<%= txtPassword.ClientID %>_err"></div>
                    </div>

                    <div class="field">
                        <label>Confirmar</label>
                        <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" />
                        <div class="field-error" id="<%= txtConfirm.ClientID %>_err"></div>
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

    <script>
      (function(){
        function el(id){ return document.getElementById(id); }
        function isEmpty(v){ return !v || String(v).trim()===""; }
        function isValidEmail(v){ return /^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/i.test(String(v||"").trim()); }
        function setFieldError(id, msg){ var e = el(id); if(!e) return; e.textContent = msg || ""; e.style.display = msg ? "block" : "none"; }

        var ids = {
          idType: "<%= ddlIdType.ClientID %>",
          idNumber: "<%= txtIdNumber.ClientID %>",
          firstName: "<%= txtFirstName.ClientID %>",
          lastName: "<%= txtLastName.ClientID %>",
          birthDate: "<%= txtBirthDate.ClientID %>",
          filial: "<%= txtFilialNumber.ClientID %>",
          email: "<%= txtEmail.ClientID %>",
          pass: "<%= txtPassword.ClientID %>",
          conf: "<%= txtConfirm.ClientID %>",
          terms: "<%= chkTerms.ClientID %>",
          btn: "<%= btnRegister.ClientID %>"
        };

        function validateForm(){
          var idType = el(ids.idType).value;
          var idNumber = el(ids.idNumber).value;
          var firstName = el(ids.firstName).value;
          var lastName = el(ids.lastName).value;
          var birthDate = el(ids.birthDate).value;
          var filial = el(ids.filial).value;
          var email = el(ids.email).value;
          var pass = el(ids.pass).value;
          var conf = el(ids.conf).value;
          var terms = el(ids.terms).checked;

          setFieldError(ids.idType + "_err", isEmpty(idType) ? "Seleccione tipo de identificación." : "");
          
          setFieldError(ids.idNumber + "_err", "");
          var idDigits = (idNumber || "").replace(/\D/g, "");
          var idValid = true;
          if (isEmpty(idNumber)) {
            idValid = false;
            setFieldError(ids.idNumber + "_err", "Identificación requerida.");
          } else if (idDigits.length < 9) {
            idValid = false;
            setFieldError(ids.idNumber + "_err", "La identificación debe tener al menos 9 dígitos.");
          } else {
            setFieldError(ids.idNumber + "_err", "");
          }
          setFieldError(ids.firstName + "_err", isEmpty(firstName) ? "Nombre requerido." : "");
          setFieldError(ids.lastName + "_err", isEmpty(lastName) ? "Apellidos requeridos." : "");
          
          
          var birthValid = true;
          if (isEmpty(birthDate)) {
            birthValid = false;
            setFieldError(ids.birthDate + "_err", "Fecha de nacimiento requerida.");
          } else {
            var bd = new Date(birthDate);
            var today = new Date();
            if (isNaN(bd.getTime())) {
              birthValid = false;
              setFieldError(ids.birthDate + "_err", "Fecha inválida.");
            } else if (bd > today) {
              birthValid = false;
              setFieldError(ids.birthDate + "_err", "La fecha no puede ser en el futuro.");
            } else {
              
              var age = today.getFullYear() - bd.getFullYear();
              var m = today.getMonth() - bd.getMonth();
              if (m < 0 || (m === 0 && today.getDate() < bd.getDate())) age--;
              if (age < 0 || age > 120) {
                birthValid = false;
                setFieldError(ids.birthDate + "_err", "Fecha de nacimiento inválida.");
              } else {
                setFieldError(ids.birthDate + "_err", "");
              }
            }
          }
          setFieldError(ids.filial + "_err", (isEmpty(filial) || isNaN(parseInt(filial,10)) || parseInt(filial,10) < 0) ? "Filial inválida." : "");
          setFieldError(ids.email + "_err", !isValidEmail(email) ? "Correo inválido." : "");
          setFieldError(ids.pass + "_err", (isEmpty(pass) || pass.length < 6) ? "Contraseña de al menos 6 caracteres." : "");
          setFieldError(ids.conf + "_err", (pass !== conf) ? "Las contraseñas no coinciden." : "");
          setFieldError(ids.terms + "_err", (!terms) ? "Debes aceptar términos." : "");

          var ok = !isEmpty(idType) && idValid && !isEmpty(firstName) && !isEmpty(lastName) &&
                   birthValid && !isEmpty(filial) && isValidEmail(email) &&
                   !isEmpty(pass) && pass.length >= 6 && pass === conf && terms;

          el(ids.btn).disabled = !ok;
        }

        document.addEventListener("input", validateForm, true);
        document.addEventListener("change", validateForm, true);
        validateForm();
      })();
    </script>

</asp:Content>
