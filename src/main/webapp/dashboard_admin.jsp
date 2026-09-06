<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.Locale"%>
<%
    LocalDate fechaActual = LocalDate.now();
    DateTimeFormatter formato = DateTimeFormatter.ofPattern("d 'de' MMMM yyyy", new Locale("es", "ES"));
    String fechaFormateada = fechaActual.format(formato);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Control - FARMAEDU ERP</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        /* =========================================
           VARIABLES Y BASE
           ========================================= */
        :root {
            --bg-sidebar: #022c22; 
            --bg-sidebar-hover: #064e3b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --bg-body: #f8fafc;
            --primary-color: #10b981;
            --danger-color: #ef4444;
        }

        body {
            background-color: var(--bg-body);
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            overflow: hidden; 
            color: #1e293b;
            height: 100vh;
            margin: 0;
        }

        .wrapper { display: flex; width: 100%; height: 100vh; }

        /* =========================================
           SIDEBAR (Panel Izquierdo)
           ========================================= */
        .sidebar {
            width: 260px;
            background-color: var(--bg-sidebar); 
            color: #a7f3d0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            border-right: 1px solid #064e3b;
        }

        .sidebar-header {
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }

        .logo-box {
            width: 32px;
            height: 32px;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-weight: bold;
        }

        .sidebar-header h5 {
            margin: 0;
            color: #ffffff;
            font-weight: 800;
            font-size: 1rem;
            letter-spacing: 0.5px;
        }
        .sidebar-header small { display: block; font-size: 0.65rem; color: #6ee7b7; }

        .sidebar-content { flex-grow: 1; overflow-y: auto; padding-top: 10px; }
        .sidebar-content::-webkit-scrollbar { display: none; }

        .sidebar-section {
            font-size: 0.65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #059669;
            padding: 15px 20px 5px 20px;
            margin: 0;
        }

        .sidebar-menu { list-style: none; padding: 0 12px; margin: 0; }
        .sidebar-menu .nav-link {
            color: #d1fae5;
            display: flex;
            align-items: center;
            padding: 9px 15px;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
            margin-bottom: 2px;
        }
        .sidebar-menu .nav-link i.icon-main { width: 25px; font-size: 0.95rem; }
        .sidebar-menu .nav-link:hover { background-color: var(--bg-sidebar-hover); color: #ffffff; }
        .sidebar-menu .nav-link.active { background-color: #047857; color: #ffffff; font-weight: 600;}

        /* Badge EN VIVO */
        .badge-live {
            background-color: #064e3b;
            color: #34d399;
            font-size: 0.6rem;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: auto;
            border: 1px solid #059669;
            animation: pulse 2s infinite;
        }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }

        /* Footer del Sidebar (Perfil) */
        .sidebar-footer {
            padding: 15px 20px;
            border-top: 1px solid rgba(255,255,255,0.05);
            display: flex;
            align-items: center;
            gap: 10px;
            background-color: #012119;
        }
        .sidebar-footer i { font-size: 1.5rem; color: #34d399; }
        .sidebar-footer div { line-height: 1.2; }
        .sidebar-footer span { font-size: 0.8rem; font-weight: 700; color: white; display: block;}
        .sidebar-footer small { font-size: 0.65rem; color: #6ee7b7; }
        .logout-btn { margin-left: auto; color: #94a3b8; cursor: pointer; transition: color 0.2s; }
        .logout-btn:hover { color: #ef4444; }

        /* =========================================
           CONTENIDO PRINCIPAL
           ========================================= */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        /* Topbar */
        .topbar {
            background-color: #ffffff;
            height: 55px; 
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 25px;
            border-bottom: 1px solid var(--border-color);
            flex-shrink: 0;
            font-size: 0.8rem;
        }

        .search-bar { display: flex; align-items: center; gap: 10px; width: 300px; color: var(--text-muted); }
        .search-bar input { border: none; outline: none; width: 100%; font-size: 0.85rem; }

        .topbar-info { display: flex; align-items: center; gap: 20px; font-weight: 500; color: #475569;}
        .topbar-info i { color: var(--primary-color); }
        .topbar-icons i { font-size: 1.1rem; color: var(--text-muted); cursor: pointer; margin-left: 15px;}
        .topbar-icons .avatar {
            width: 28px; height: 28px; background: #0f172a; color: white; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-left: 15px; font-weight: bold;
        }

        /* Área Scrollable */
        .content-area {
            padding: 24px 30px;
            overflow-y: auto; 
            height: calc(100vh - 55px);
            background-color: #f1f5f9;
        }

        /* Header de Acciones (Título + Botones) */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 24px;
        }
        .page-title span { font-size: 0.7rem; font-weight: 700; color: var(--primary-color); letter-spacing: 1px; text-transform: uppercase;}
        .page-title h2 { font-weight: 800; font-size: 1.7rem; margin: 4px 0; color: #0f172a; letter-spacing: -0.5px;}
        .page-title p { color: var(--text-muted); font-size: 0.85rem; margin: 0; display: flex; align-items: center; gap: 6px;}
        
        .header-actions { display: flex; gap: 12px; }
        .btn-action {
            background: white; border: 1px solid var(--border-color); padding: 8px 15px;
            border-radius: 8px; font-size: 0.8rem; font-weight: 600; color: #334155;
            display: flex; align-items: center; gap: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }
        .btn-action-primary {
            background: var(--primary-color); border: none; color: white;
            box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
        }

        /* Tarjetas de Datos (Métricas) */
        .metric-card {
            background: white; border-radius: 12px; padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .metric-header { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase;}
        .metric-header i { font-size: 1rem; color: #94a3b8; }
        .metric-value { font-size: 1.8rem; font-weight: 800; color: #0f172a; margin-bottom: 5px; line-height: 1.1;}
        .metric-sub { font-size: 0.75rem; color: var(--text-muted); display: flex; align-items: center; gap: 5px;}
        .trend-up { color: var(--primary-color); font-weight: 600;}
        .trend-down { color: var(--danger-color); font-weight: 600;}

        /* Contenedores Generales */
        .panel-card {
            background: white; border-radius: 12px; padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
            margin-bottom: 24px;
        }
        .panel-title { font-size: 1rem; font-weight: 700; color: #0f172a; margin-bottom: 5px; display: flex; justify-content: space-between; align-items: center;}
        .panel-subtitle { font-size: 0.75rem; color: var(--text-muted); margin-bottom: 15px;}

        /* Lista de Monitoreo FEFO */
        .fefo-item {
            border: 1px solid #f1f5f9; border-left: 3px solid var(--danger-color);
            border-radius: 6px; padding: 12px; margin-bottom: 10px;
            background: #fafafa;
        }
        .fefo-item.warning { border-left-color: #f59e0b; }
        .fefo-head { display: flex; justify-content: space-between; font-size: 0.85rem; font-weight: 700; color: #1e293b; margin-bottom: 4px;}
        .fefo-badge { font-size: 0.65rem; padding: 2px 6px; border-radius: 4px; font-weight: 700; background: #fee2e2; color: #b91c1c; }
        .fefo-badge.warning { background: #fef3c7; color: #b45309; }
        .fefo-details { font-size: 0.7rem; color: var(--text-muted); }
        .fefo-action { display: flex; align-items: center; gap: 5px; font-size: 0.7rem; color: #0ea5e9; font-weight: 600; margin-top: 8px; cursor: pointer;}

        /* Tabla de Últimos Despachos */
        .table-pos { width: 100%; font-size: 0.8rem; }
        .table-pos th { text-transform: uppercase; font-size: 0.65rem; color: var(--text-muted); font-weight: 700; padding-bottom: 10px; border-bottom: 1px solid var(--border-color);}
        .table-pos td { padding: 12px 0; border-bottom: 1px solid #f1f5f9; vertical-align: middle; color: #334155;}
        .table-pos .fw-bold { color: #0f172a; }
        .pay-badge { font-size: 0.7rem; padding: 4px 8px; border-radius: 6px; font-weight: 600; background: #f1f5f9; border: 1px solid #e2e8f0; display: inline-flex; align-items: center; gap: 5px;}
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <div class="logo-box"><i class="fa-solid fa-plus"></i></div>
                <div>
                    <h5>FARMAEDU</h5>
                    <small>HEALTHCARE ERP SUITE</small>
                </div>
            </div>

            <div class="sidebar-content">
                <p class="sidebar-section">Principal</p>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="DashboardServlet" class="nav-link active"><i class="fa-solid fa-border-all icon-main"></i> Dashboard General</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-desktop icon-main"></i> Punto de Venta (POS) <span class="badge-live">EN VIVO</span></a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-cash-register icon-main"></i> Caja y Turnos</a></li>
                </ul>

                <p class="sidebar-section">Gestión Farmacéutica</p>
                <ul class="sidebar-menu">
                    <!-- ENLACE DE INVENTARIO CORREGIDO -->
                    <li class="nav-item"><a href="InventarioServlet?accion=listar" class="nav-link"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario & Lotes (FEFO)</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-truck-ramp-box icon-main"></i> Compras y Proveedores</a></li>
                    <li class="nav-item"><a href="MedicamentoServlet?accion=listar" class="nav-link"><i class="fa-solid fa-book-medical icon-main"></i> Catálogo Maestro</a></li>
                    <li class="nav-item"><a href="ClienteServlet?accion=listar" class="nav-link"><i class="fa-solid fa-users icon-main"></i> Clientes y Pacientes</a></li>
                </ul>

                <p class="sidebar-section">Reportes & Configuración</p>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-chart-line icon-main"></i> Ventas y Finanzas</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-user-shield icon-main"></i> Usuarios y Permisos</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-sliders icon-main"></i> Ajustes del Sistema</a></li>
                </ul>
            </div>
            
            <!-- Footer del Sidebar -->
            <div class="sidebar-footer">
                <i class="fa-solid fa-user-doctor"></i>
                <div>
                    <span>Admin Farmacia</span>
                    <small>Regente / Admin</small>
                </div>
                <i class="fa-solid fa-arrow-right-from-bracket logout-btn" onclick="window.location.href='index.jsp'"></i>
            </div>
        </nav>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="main-content">
            
            <!-- TOPBAR -->
            <header class="topbar">
                <div class="search-bar">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Buscar medicamentos, DNI o comprobante...">
                </div>
                <div class="topbar-info">
                    <span><i class="fa-solid fa-store me-1"></i> Sede Chiclayo</span>
                    <span><i class="fa-regular fa-clock me-1"></i> Turno Mañana (Caja 01)</span>
                </div>
                <div class="topbar-icons">
                    <i class="fa-regular fa-bell"></i>
                    <div class="avatar">A</div>
                </div>
            </header>

            <!-- ÁREA SCROLLABLE -->
            <div class="content-area">
                
                <!-- HEADER DE ACCIONES -->
                <div class="page-header">
                    <div class="page-title">
                        <span>Sede Operativa</span>
                        <h2>Panel de Control Farmacéutico</h2>
                        <p><i class="fa-solid fa-shield-check text-success"></i> Resumen operativo en tiempo real | Sede Chiclayo</p>
                    </div>
                    <div class="header-actions">
                        <div class="btn-action">
                            <i class="fa-regular fa-calendar"></i>
                            <div>
                                <div style="font-size: 0.6rem; color: var(--text-muted); line-height: 1;">JORNADA ACTIVA</div>
                                <div>Hoy, <%= fechaFormateada %></div>
                            </div>
                        </div>
                        <button class="btn-action"><i class="fa-solid fa-box-open text-primary"></i> Ingreso Lote / Factura</button>
                        <button class="btn-action btn-action-primary"><i class="fa-solid fa-plus"></i> Nueva Venta POS</button>
                    </div>
                </div>

                <!-- ROW 1: KPIs (Datos conectados a la BD) -->
                <div class="row g-3 mb-4">
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Ventas Netas del Día <i class="fa-solid fa-money-bill-wave text-success"></i></div>
                            <div>
                                <div class="metric-value">S/ ${String.format("%.2f", kpiIngresos != null ? kpiIngresos : 0.00)}</div>
                                <div class="metric-sub"><span class="trend-up"><i class="fa-solid fa-arrow-trend-up"></i> +12.4%</span> vs. ayer</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header text-danger">Alertas FEFO (Lotes) <i class="fa-solid fa-triangle-exclamation text-danger"></i></div>
                            <div>
                                <div class="metric-value text-danger">${kpiAlertas != null ? kpiAlertas : 0} Lotes</div>
                                <div class="metric-sub">Próximos a vencer (< 90 días)</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Comprobantes Emitidos <i class="fa-solid fa-receipt text-primary"></i></div>
                            <div>
                                <div class="metric-value">${kpiVentas != null ? kpiVentas : 0}</div>
                                <div class="metric-sub">Boletas y Facturas hoy</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="metric-card">
                            <div class="metric-header">Clientes Atendidos <i class="fa-solid fa-hospital-user text-info"></i></div>
                            <div>
                                <div class="metric-value">${kpiClientes != null ? kpiClientes : 0} Reg.</div>
                                <div class="metric-sub">Total registrados en cartera</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ROW 2: Gráfico y Lotes FEFO -->
                <div class="row g-3 mb-4">
                    <!-- GRÁFICO TENDENCIA -->
                    <div class="col-lg-8">
                        <div class="panel-card h-100 mb-0">
                            <div class="panel-title">Tendencia de Ventas (Últimos 7 días) <span class="badge bg-light text-dark border"><i class="fa-solid fa-chart-area"></i> Flujo</span></div>
                            <div class="panel-subtitle">Comportamiento de demanda farmacéutica y dispensación en mostrador.</div>
                            <div style="position: relative; height: 250px; width: 100%;">
                                <canvas id="areaChart"></canvas>
                            </div>
                        </div>
                    </div>
                    
                    <!-- MONITOREO FEFO -->
                    <div class="col-lg-4">
                        <div class="panel-card h-100 mb-0">
                            <div class="panel-title">Monitoreo Crítico FEFO <span class="badge bg-danger">URGENTE</span></div>
                            <div class="panel-subtitle">Lotes de inventario próximos a vencer.</div>
                            
                            <!-- Ítem FEFO (Datos de ejemplo basados en tu BD) -->
                            <div class="fefo-item">
                                <div class="fefo-head">
                                    <span>Paracetamol 500mg</span>
                                    <span class="fefo-badge"><i class="fa-regular fa-clock"></i> 14 Días</span>
                                </div>
                                <div class="fefo-details">Lote: LT-2024-001 • Stock Real: 100 unid.</div>
                                <div class="fefo-action"><i class="fa-solid fa-rotate"></i> Prioridad alta de despacho en mostrador</div>
                            </div>

                            <div class="fefo-item warning">
                                <div class="fefo-head">
                                    <span>Amoxicilina 500mg</span>
                                    <span class="fefo-badge warning"><i class="fa-regular fa-clock"></i> 45 Días</span>
                                </div>
                                <div class="fefo-details">Lote: LT-AMOX-88 • Stock Real: 35 cajas</div>
                                <div class="fefo-action" style="color:#d97706;"><i class="fa-solid fa-tags"></i> Sugerir promoción por vencimiento</div>
                            </div>
                            
                            <button class="btn btn-light w-100 border mt-2 shadow-sm" style="font-size:0.8rem; font-weight:600;"><i class="fa-solid fa-list-check"></i> Ver Reporte FEFO Completo</button>
                        </div>
                    </div>
                </div>

                <!-- ROW 3: Tabla de Últimos Despachos (Conectada a Tablas Ventas/Detalles) -->
                <div class="row g-3">
                    <div class="col-12">
                        <div class="panel-card mb-0">
                            <div class="panel-title">
                                <div><i class="fa-solid fa-cash-register me-2"></i> Últimos Despachos y Ventas en Caja (POS)</div>
                                <a href="#" class="btn btn-sm btn-outline-success border-0" style="font-size:0.75rem; font-weight:700;">Ver Terminal POS <i class="fa-solid fa-arrow-right"></i></a>
                            </div>
                            <div class="panel-subtitle">Registro transaccional electrónico en tiempo real validado por SUNAT.</div>
                            
                            <div class="table-responsive">
                                <table class="table-pos">
                                    <thead>
                                        <tr>
                                            <th>Comprobante</th>
                                            <th>Cliente / Paciente</th>
                                            <th>Medicamento (Ejemplo)</th>
                                            <th>Total (S/)</th>
                                            <th>Método de Pago</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Ejemplos estructurales listos para el <c:forEach> de JSTL -->
                                        <tr>
                                            <td class="fw-bold">BV-004281</td>
                                            <td>Mariana Morales R. <br><small class="text-muted">DNI: 45992147</small></td>
                                            <td>Amoxicilina 500mg (x2 cajas)</td>
                                            <td class="fw-bold">S/ 24.50</td>
                                            <td><span class="pay-badge"><i class="fa-brands fa-cc-visa text-primary"></i> Tarjeta Visa</span></td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">FT-001092</td>
                                            <td>Clínica San Borja S.A.C. <br><small class="text-muted">RUC: 20554918131</small></td>
                                            <td>Glucerna Polvo Vainilla (x6)</td>
                                            <td class="fw-bold">S/ 894.00</td>
                                            <td><span class="pay-badge"><i class="fa-solid fa-building-columns text-success"></i> Transf. Bancaria</span></td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">BV-004282</td>
                                            <td>Cliente Público General</td>
                                            <td>Sal de Andrews (x5 sobres)</td>
                                            <td class="fw-bold">S/ 2.50</td>
                                            <td><span class="pay-badge"><i class="fa-solid fa-money-bill text-success"></i> Efectivo</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        // Configuración de Chart.js para simular el gráfico de Área suave (Tendencia) de la imagen
        const ctxArea = document.getElementById('areaChart').getContext('2d');
        
        // Crear gradiente para rellenar debajo de la línea
        let gradient = ctxArea.createLinearGradient(0, 0, 0, 250);
        gradient.addColorStop(0, 'rgba(16, 185, 129, 0.2)'); // Verde claro
        gradient.addColorStop(1, 'rgba(16, 185, 129, 0)');   // Transparente

        new Chart(ctxArea, {
            type: 'line',
            data: {
                labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Hoy'],
                datasets: [{
                    label: 'Ventas (S/)',
                    data: [1200, 1900, 1500, 2100, 1800, 2500, 1485],
                    borderColor: '#10b981',
                    backgroundColor: gradient,
                    borderWidth: 2,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#10b981',
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4 // Hace que la línea sea curva y suave
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false, 
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false } },
                    y: { border: { display: false }, grid: { color: '#f1f5f9' } }
                }
            }
        });
    </script>
</body>
</html>