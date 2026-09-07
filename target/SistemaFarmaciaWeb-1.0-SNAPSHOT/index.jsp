<%-- 
    Document   : index
    Created on : 6 sept 2026, 4:16:50 p.m.
    Author     : javie
--%>

<%@page import="java.time.Year"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <title>FARMAEDU</title>
    <!-- Bootstrap y FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

    <div class="wrapper-login">

        <!-- PANEL IZQUIERDO -->
        <div class="left-panel">
            <div class="brand-header">
                <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
                <div class="brand-text">
                    <h4>FARMAEDU</h4>
                    <span>Plataforma web de gestión farmacéutica</span>
                </div>
            </div>

            <div class="hero-section">
                <h1>Sistema integral de gestión farmacéutica y <span>punto de venta inteligente.</span></h1>
                <p>Control de inventarios por lotes, emisión de comprobantes de pago electrónicos y trazabilidad sanitaria en tiempo real para farmacias y cadenas asistenciales.</p>

                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-receipt"></i></div>
                            <span class="feature-badge">99.99% SLA</span>
                        </div>
                        <h6>POS & Comprobantes Electrónicos</h6>
                        <p>Ventas con cuadre de caja y emisión de facturas, boletas y notas electrónicas.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-box-open"></i></div>
                            <span class="feature-badge">ALERTAS FEFO</span>
                        </div>
                        <h6>Stock & Vencimientos</h6>
                        <p>Registro de lotes, fechas de vencimiento y trazabilidad del medicamento.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-shield-halved"></i></div>
                            <span class="feature-badge">AES-256</span>
                        </div>
                        <h6>Seguridad Clínica</h6>
                        <p>Control de usuarios, roles farmacéuticos y registro inmutable de cada operación del sistema.</p>
                    </div>
                </div>
            </div>

            <div class="trusted-badge">
                <span class="text-success fw-bold">FARMAEDU +</span>
                Desarrollado para el sector farmacéutico peruano
            </div>
        </div>

        <!-- PANEL DERECHO -->
        <div class="right-panel">
            <div class="login-container">

                <h2>Bienvenido de nuevo</h2>
                <p>Ingresa tus credenciales autorizadas para gestionar el sistema farmacéutico.</p>

                <form action="LoginServlet" method="POST">

                    <!-- Alerta de Error -->
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger p-2 text-center small rounded-3 border-0 bg-danger text-white mb-3 fw-bold">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <label class="form-label-custom">Correo electrónico o ID de Usuario</label>
                    <div class="input-group-custom">
                        <i class="fa-regular fa-user icon-left"></i>
                        <input type="text" id="userLogin" name="txtUser" class="form-control-custom" placeholder="admin" required autocomplete="username">
                    </div>

                    <label class="form-label-custom">
                        Contraseña
                        <a href="#">¿Olvidaste tu contraseña?</a>
                    </label>
                    <div class="input-group-custom">
                        <i class="fa-solid fa-lock icon-left"></i>
                        <input type="password" id="passLogin" name="txtPass" class="form-control-custom" placeholder="••••••••" required autocomplete="current-password">
                        <i class="fa-regular fa-eye icon-right" onclick="togglePassword()"></i>
                    </div>

                    <div class="form-check custom-checkbox mb-3">
                        <input class="form-check-input" type="checkbox" id="checkRecordar" checked>
                        <label class="form-check-label" for="checkRecordar">
                            Recordar estación de trabajo por 30 días
                        </label>
                    </div>

                    <button type="submit" name="accion" value="Ingresar" class="btn-submit">
                        Iniciar Sesión en FARMAEDU <i class="fa-solid fa-arrow-right"></i>
                    </button>

                    <div class="demo-box">
                        <i class="fa-solid fa-circle-info"></i>
                        <div class="demo-box-content">
                            <div class="demo-header">
                                <span>Credenciales Demo (Entorno Sandbox) <span class="badge-activo">ACTIVO</span></span>
                                <button type="button" class="btn-auto" onclick="autocompletar()">Autocompletar</button>
                            </div>
                            <p class="demo-creds">Usuario: <strong>admin</strong> | Contraseña: <strong>admin123</strong></p>
                        </div>
                    </div>

                </form>
            </div>

            <!-- Footer con año dinámico -->
            <div class="right-footer">
                <span>© <%= Year.now().getValue() %> FARMAEDU S.A.C. Todos los derechos reservados.</span>
                <div>
                    <a href="#">Privacidad</a>
                    <a href="#">Términos</a>
                </div>
            </div>
        </div>

    </div>

    <script>
        function togglePassword() {
            const passInput = document.getElementById('passLogin');
            const icon = document.querySelector('.icon-right');
            if (passInput.type === "password") {
                passInput.type = "text";
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                passInput.type = "password";
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        function autocompletar() {
            document.getElementById('userLogin').value = 'admin';
            document.getElementById('passLogin').value = 'admin123';
        }
    </script>
</body>
</html>
