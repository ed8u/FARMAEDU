<%@page import="java.time.Year"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Acceso - FARMAEDU</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    </head>
<body class="login-body">

    <div class="login-card">
        
        <!-- MITAD IZQUIERDA -->
        <div class="login-brand">
            <div>
                <div class="brand-logo"><i class="fa-solid fa-plus"></i></div>
                <div class="brand-title">
                    <h1>FARMAEDU</h1>
                    <p>Sistema integral de gestión farmacéutica y punto de venta inteligente.</p>
                </div>
            </div>
            
            <div class="brand-footer">
                © <%= Year.now().getValue() %> FARMAEDU S.A.C.<br>
                Uso exclusivo autorizado.
            </div>
        </div>

        <!-- MITAD DERECHA -->
        <div class="login-form-container">
            <h2>Acceso al Sistema</h2>
            <p>Ingresa tus credenciales para continuar.</p>

            <form action="LoginServlet" method="POST">

                <!-- Alerta de Error -->
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger py-2 text-center small rounded-2 bg-danger text-white border-0 fw-bold mb-4">
                        <i class="fa-solid fa-circle-exclamation me-1"></i> <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <div>
                    <label class="form-label-custom">Usuario o Correo</label>
                    <input type="text" id="userLogin" name="txtUser" class="input-custom" placeholder="Ej: admin" required autocomplete="username">
                </div>

                <div class="password-container">
                    <div class="d-flex justify-content-between">
                        <label class="form-label-custom">Contraseña</label>
                    </div>
                    <input type="password" id="passLogin" name="txtPass" class="input-custom" placeholder="••••••••" required autocomplete="current-password">
                    <i class="fa-regular fa-eye toggle-pass" onclick="togglePassword()"></i>
                </div>

                <button type="submit" name="accion" value="Ingresar" class="btn-login">
                    Iniciar Sesión
                </button>

                <!-- Área Demo Limpia -->
                <div class="demo-box">
                    <div class="demo-text">
                        <strong>Demo:</strong> admin / admin123
                    </div>
                    <button type="button" class="btn-auto" onclick="autocompletar()">Completar</button>
                </div>

            </form>
        </div>

    </div>

    <script>
        function togglePassword() {
            const passInput = document.getElementById('passLogin');
            const icon = document.querySelector('.toggle-pass');
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