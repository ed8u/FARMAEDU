<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Botica - Enterprise Healthcare Suite</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            background-color: #ffffff;
            overflow-x: hidden;
        }

        .wrapper-login {
            display: flex;
            min-height: 100vh;
        }

        /* =========================================
           PANEL IZQUIERDO (Dark Green)
           ========================================= */
        .left-panel {
            background-color: #022c22; /* Verde muy oscuro */
            /* Patrón de cuadrícula de fondo sutil */
            background-image: 
                linear-gradient(rgba(255,255,255,0.03) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.03) 1px, transparent 1px);
            background-size: 40px 40px;
            color: white;
            padding: 3rem 4rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            width: 50%;
        }

        /* Branding Superior */
        .brand-header {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .logo-box {
            width: 35px;
            height: 35px;
            background-color: transparent;
            border: 1px solid #10b981;
            color: #10b981;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-size: 1.2rem;
            font-weight: bold;
        }
        .brand-text h4 { margin: 0; font-weight: 800; font-size: 1.2rem; letter-spacing: 1px; color: #ffffff;}
        .brand-text span { font-size: 0.6rem; font-weight: 600; color: #34d399; letter-spacing: 1px; text-transform: uppercase;}

        /* Textos Principales */
        .hero-section {
            margin-top: -4rem; /* Centrado visual */
        }
        .hero-section h1 {
            font-size: 2.8rem;
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 1.5rem;
            letter-spacing: -1px;
        }
        .hero-section h1 span { color: #34d399; } /* Resalta "punto de venta inteligente" */
        .hero-section p {
            color: #a7f3d0;
            font-size: 1rem;
            line-height: 1.6;
            max-width: 90%;
            margin-bottom: 3rem;
            font-weight: 300;
        }

        /* Tarjetas de Características */
        .features-grid {
            display: flex;
            gap: 15px;
        }
        .feature-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 20px;
            flex: 1;
            transition: all 0.3s;
        }
        .feature-card:hover {
            background: rgba(255, 255, 255, 0.06);
            border-color: rgba(52, 211, 153, 0.3);
        }
        .feature-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .feature-icon {
            width: 32px;
            height: 32px;
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }
        .feature-badge {
            font-size: 0.6rem;
            font-weight: 700;
            color: #34d399;
            letter-spacing: 0.5px;
        }
        .feature-card h6 { font-weight: 700; font-size: 0.9rem; margin-bottom: 6px; }
        .feature-card p { font-size: 0.75rem; color: #94a3b8; margin: 0; line-height: 1.4; }

        /* Footer Izquierdo */
        .trusted-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: rgba(0,0,0,0.2);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            color: #cbd5e1;
            border: 1px solid rgba(255,255,255,0.05);
        }

        /* =========================================
           PANEL DERECHO (Formulario de Login)
           ========================================= */
        .right-panel {
            width: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #ffffff;
            position: relative;
        }
        .login-container {
            width: 100%;
            max-width: 440px;
            padding: 2rem;
        }

        .login-container h2 {
            font-weight: 800;
            font-size: 1.8rem;
            color: #0f172a;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        .login-container > p {
            color: #64748b;
            font-size: 0.9rem;
            margin-bottom: 2.5rem;
            line-height: 1.5;
        }

        /* Labels y Formulario */
        .form-label-custom {
            font-size: 0.65rem;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
            display: flex;
            justify-content: space-between;
        }
        .form-label-custom a {
            color: #10b981;
            text-decoration: none;
            text-transform: none;
            letter-spacing: 0;
            font-weight: 600;
        }

        /* Inputs con Íconos integrados */
        .input-group-custom {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .input-group-custom i.icon-left {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 0.9rem;
        }
        .input-group-custom i.icon-right {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 0.9rem;
            cursor: pointer;
        }
        .form-control-custom {
            width: 100%;
            padding: 12px 15px 12px 40px; /* Espacio para el ícono izquierdo */
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            color: #1e293b;
            transition: all 0.2s;
            background-color: #ffffff;
        }
        .form-control-custom:focus {
            border-color: #10b981;
            outline: none;
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }

        /* Checkbox */
        .custom-checkbox .form-check-input {
            border-color: #cbd5e1;
            cursor: pointer;
        }
        .custom-checkbox .form-check-input:checked {
            background-color: #10b981;
            border-color: #10b981;
        }
        .custom-checkbox label {
            font-size: 0.8rem;
            color: #475569;
            cursor: pointer;
            font-weight: 500;
        }

        /* Botón Submit */
        .btn-submit {
            background-color: #059669; /* Verde oscuro del botón */
            color: white;
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.95rem;
            margin-top: 1rem;
            margin-bottom: 2rem;
            transition: background-color 0.2s;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }
        .btn-submit:hover { background-color: #047857; }

        /* Caja de Credenciales Demo */
        .demo-box {
            background-color: #ecfdf5; /* Verde muy clarito */
            border: 1px solid #a7f3d0;
            border-radius: 8px;
            padding: 15px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }
        .demo-box i { color: #10b981; margin-top: 2px; }
        .demo-box-content { flex-grow: 1; }
        
        .demo-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }
        .demo-header span {
            font-size: 0.8rem;
            font-weight: 700;
            color: #065f46;
        }
        .badge-activo {
            background-color: #10b981;
            color: white;
            font-size: 0.55rem;
            padding: 2px 6px;
            border-radius: 4px;
            letter-spacing: 0.5px;
        }
        .demo-creds {
            font-size: 0.75rem;
            color: #047857;
            font-family: monospace;
            margin: 0;
        }
        .btn-auto {
            background: white;
            border: 1px solid #a7f3d0;
            color: #059669;
            font-size: 0.7rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-auto:hover { background: #d1fae5; }

        /* Footer Derecho */
        .right-footer {
            position: absolute;
            bottom: 2rem;
            width: 100%;
            padding: 0 4rem;
            display: flex;
            justify-content: space-between;
            font-size: 0.7rem;
            color: #94a3b8;
        }
        .right-footer a { color: #94a3b8; text-decoration: none; margin-left: 15px; }

        /* Responsividad Básica */
        @media (max-width: 992px) {
            .left-panel { display: none; }
            .right-panel { width: 100%; }
        }
    </style>
</head>
<body>

    <div class="wrapper-login">
        
        <!-- PANEL IZQUIERDO (Informativo y Branding) -->
        <div class="left-panel">
            
            <div class="brand-header">
                <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
                <div class="brand-text">
                    <h4>FARMAEDU</h4>
                    <span>Proyecto WEB INTEGRADO</span>
                </div>
            </div>

            <div class="hero-section">
                <h1>Sistema integral de gestión farmacéutica y <span>punto de venta inteligente.</span></h1>
                <p>Control de inventarios por lotes, facturación electrónica homologada, auditoría clínica y trazabilidad sanitaria en tiempo real para farmacias y cadenas asistenciales.</p>
                
                <div class="features-grid">
                    <!-- Tarjeta 1 -->
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-receipt"></i></div>
                            <span class="feature-badge">99.99% SLA</span>
                        </div>
                        <h6>POS & Facturación</h6>
                        <p>Ventas ágiles, caja cuadre ciego y emisión tributaria inmediata.</p>
                    </div>
                    <!-- Tarjeta 2 -->
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-box-open"></i></div>
                            <span class="feature-badge">ALERTAS FEFO</span>
                        </div>
                        <h6>Stock & Vencimientos</h6>
                        <p>Control estricto de lotes, recetas médicas y trazabilidad sanitaria.</p>
                    </div>
                    <!-- Tarjeta 3 -->
                    <div class="feature-card">
                        <div class="feature-header">
                            <div class="feature-icon"><i class="fa-solid fa-shield-halved"></i></div>
                            <span class="feature-badge">AES-256</span>
                        </div>
                        <h6>Seguridad Clínica</h6>
                        <p>Auditoría granular de usuarios, roles farmacéuticos y logs inmutables.</p>
                    </div>
                </div>
            </div>

            <div class="trusted-badge">
                <span class="text-success fw-bold">FARMAEDU +1k</span>
                Confiado por +1,200 farmacias
            </div>
            
        </div>

        <!-- PANEL DERECHO (Formulario de Acceso) -->
        <div class="right-panel">
            <div class="login-container">
                
                <h2>Bienvenido de nuevo</h2>
                <p>Ingresa tus credenciales autorizadas para gestionar el sistema farmacéutico.</p>

                <form action="LoginServlet" method="POST">
                    
                    <!-- Mensaje de Error de Credenciales (Viene del Servlet) -->
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger p-2 text-center small rounded-3 border-0 bg-danger text-white mb-3 fw-bold">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>

                    <!-- Input Correo/Usuario -->
                    <label class="form-label-custom">Correo electrónico o ID de Usuario</label>
                    <div class="input-group-custom">
                        <i class="fa-regular fa-user icon-left"></i>
                        <!-- El ID userLogin servirá para autocompletar -->
                        <input type="text" id="userLogin" name="txtUser" class="form-control-custom" placeholder="admin" required autocomplete="off">
                    </div>
                    
                    <!-- Input Contraseña -->
                    <label class="form-label-custom">
                        Contraseña
                        <a href="#">¿Olvidaste tu contraseña?</a>
                    </label>
                    <div class="input-group-custom">
                        <i class="fa-solid fa-lock icon-left"></i>
                        <input type="password" id="passLogin" name="txtPass" class="form-control-custom" placeholder="••••••••" required>
                        <i class="fa-regular fa-eye icon-right" onclick="togglePassword()"></i>
                    </div>
                    
                    <!-- Checkbox Recordar -->
                    <div class="form-check custom-checkbox mb-3">
                        <input class="form-check-input" type="checkbox" id="checkRecordar" checked>
                        <label class="form-check-label" for="checkRecordar">
                            Recordar estación de trabajo por 30 días
                        </label>
                    </div>
                    
                    <!-- Botón Ingresar -->
                    <button type="submit" name="accion" value="Ingresar" class="btn-submit">
                        Iniciar Sesión en FARMAEDU <i class="fa-solid fa-arrow-right"></i>
                    </button>
                    
                    <!-- Caja de Entorno de Prueba -->
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

            <!-- Footer Inferior Derecho -->
            <div class="right-footer">
                <span>© 2026 FARMAEDU S.A.C. Todos los derechos reservados.</span>
                <div>
                    <a href="#">Privacidad</a>
                    <a href="#">Términos</a>
                </div>
            </div>
        </div>

    </div>

    <!-- Script para funciones UI del Formulario -->
    <script>
        // Función para mostrar/ocultar contraseña al dar clic en el ícono del ojo
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

        // Función para el botón autocompletar
        function autocompletar() {
            document.getElementById('userLogin').value = 'admin';
            document.getElementById('passLogin').value = 'admin123';
        }
    </script>
</body>
</html>