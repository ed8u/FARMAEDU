<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventario y Lotes FEFO - FARMAEDU ERP</title>
    
    <!-- Bootstrap 5 & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.2/css/buttons.bootstrap5.min.css">
    
    <style>
        :root {
            --bg-sidebar: #022c22; 
            --bg-sidebar-hover: #064e3b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --bg-body: #f8fafc;
            --primary-color: #059669; 
        }

        body { background-color: var(--bg-body); font-family: 'Inter', system-ui, sans-serif; overflow: hidden; height: 100vh; margin: 0; color: #1e293b; }
        .wrapper { display: flex; width: 100%; height: 100vh; }

        /* SIDEBAR COMPLETO */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); color: #a7f3d0; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-header { padding: 20px; display: flex; align-items: center; gap: 12px; background-color: #012119; }
        .logo-box { width: 32px; height: 32px; border: 1px solid #10b981; color: #10b981; display: flex; align-items: center; justify-content: center; border-radius: 6px; font-weight: bold; }
        .sidebar-header h5 { margin: 0; color: #ffffff; font-weight: 800; font-size: 1.1rem; }
        .sidebar-header small { display: block; font-size: 0.6rem; color: #6ee7b7; text-transform: uppercase; letter-spacing: 1px;}
        
        .sidebar-content { flex-grow: 1; overflow-y: auto; padding-top: 10px; }
        .sidebar-content::-webkit-scrollbar { display: none; }
        .sidebar-section { font-size: 0.65rem; font-weight: 700; text-transform: uppercase; color: #059669; padding: 15px 20px 5px 20px; margin: 0; letter-spacing: 0.5px;}
        .sidebar-menu { list-style: none; padding: 0 12px; margin: 0; }
        .sidebar-menu .nav-link { color: #d1fae5; display: flex; align-items: center; padding: 9px 15px; border-radius: 8px; font-size: 0.8rem; font-weight: 500; text-decoration: none; margin-bottom: 2px; transition: all 0.2s;}
        .sidebar-menu .nav-link i.icon-main { width: 25px; font-size: 0.95rem; }
        .sidebar-menu .nav-link:hover { background-color: var(--bg-sidebar-hover); color: #ffffff; }
        .sidebar-menu .nav-link.active { background-color: #047857; color: #ffffff; font-weight: 600;}
        
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.05); display: flex; align-items: center; gap: 10px; background-color: #012119; }
        .sidebar-footer i { font-size: 1.5rem; color: #34d399; }
        .sidebar-footer div { line-height: 1.2; }
        .sidebar-footer span { font-size: 0.8rem; font-weight: 700; color: white; display: block;}
        .sidebar-footer small { font-size: 0.65rem; color: #6ee7b7; }
        .logout-btn { margin-left: auto; color: #94a3b8; cursor: pointer; transition: color 0.2s;}
        .logout-btn:hover { color: #ef4444; }

        /* CONTENIDO PRINCIPAL */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; height: 100vh; }
        .topbar { background-color: #ffffff; height: 55px; display: flex; justify-content: space-between; align-items: center; padding: 0 25px; border-bottom: 1px solid var(--border-color); flex-shrink: 0; font-size: 0.8rem; }
        .search-bar { display: flex; align-items: center; gap: 10px; width: 300px; color: var(--text-muted); }
        .search-bar input { border: none; outline: none; width: 100%; font-size: 0.85rem; }
        .topbar-info { display: flex; align-items: center; gap: 20px; font-weight: 500; color: #475569;}
        .topbar-icons .avatar { width: 28px; height: 28px; background: #0f172a; color: white; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-left: 15px; font-weight: bold; }

        .content-area { padding: 24px 30px; overflow-y: auto; height: calc(100vh - 55px); background-color: #f1f5f9; }
        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .page-title span { font-size: 0.65rem; font-weight: 700; color: var(--primary-color); letter-spacing: 1px; text-transform: uppercase;}
        .page-title h2 { font-weight: 800; font-size: 1.6rem; margin: 4px 0; color: #0f172a; }
        .page-title p { color: var(--text-muted); font-size: 0.85rem; margin: 0; }
        
        .header-actions { display: flex; gap: 10px; }
        .btn-action { background: white; border: 1px solid var(--border-color); padding: 8px 15px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; color: #334155; display: flex; align-items: center; gap: 8px; }
        .btn-primary-custom { background: var(--primary-color); border: none; color: white; }

        .kpi-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; height: 100%;}
        .kpi-header { display: flex; justify-content: space-between; font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase;}
        .kpi-value { font-size: 1.8rem; font-weight: 800; color: #0f172a; margin: 10px 0 5px 0;}
        .kpi-sub { font-size: 0.75rem; color: var(--text-muted); }

        .table-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); margin-top: 24px;}
        .table-custom { width: 100%; font-size: 0.85rem;}
        .table-custom th { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;}
        .table-custom td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle;}
        
        .badge-vencido { background: #fee2e2; color: #991b1b; font-size: 0.65rem; font-weight: 700; padding: 4px 8px; border-radius: 4px; border: 1px solid #f87171;}
        .badge-proximo { background: #fef3c7; color: #92400e; font-size: 0.65rem; font-weight: 700; padding: 4px 8px; border-radius: 4px; border: 1px solid #fcd34d;}
        .badge-ok { background: #dcfce7; color: #166534; font-size: 0.65rem; font-weight: 700; padding: 4px 8px; border-radius: 4px; border: 1px solid #4ade80;}

        /* DataTables Customization */
        .dataTables_wrapper .dataTables_filter input { border: 1px solid #e2e8f0; border-radius: 6px; padding: 4px 10px; margin-left: 10px; outline: none;}
        .dt-buttons .btn { margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- SIDEBAR IDÉNTICO AL RESTO DEL SISTEMA -->
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
                    <li class="nav-item"><a href="DashboardServlet" class="nav-link"><i class="fa-solid fa-border-all icon-main"></i> Dashboard General</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-desktop icon-main"></i> Punto de Venta (POS)</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-cash-register icon-main"></i> Caja y Turnos</a></li>
                </ul>

                <p class="sidebar-section">Gestión Farmacéutica</p>
                <ul class="sidebar-menu">
                    <li class="nav-item"><a href="InventarioServlet?accion=listar" class="nav-link active"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario & Lotes (FEFO)</a></li>
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
            
            <div class="sidebar-footer">
                <i class="fa-solid fa-user-doctor"></i>
                <div>
                    <span>Admin Farmacia</span>
                    <small>Sede Central</small>
                </div>
                <i class="fa-solid fa-arrow-right-from-bracket logout-btn" onclick="window.location.href='index.jsp'"></i>
            </div>
        </nav>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="main-content">
            <header class="topbar">
                <div class="search-bar">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" placeholder="Buscar lote, medicamento o compra...">
                </div>
                <div class="topbar-info">
                    <span><i class="fa-solid fa-store me-1 text-success"></i> Sucursal Principal</span>
                </div>
                <div class="topbar-icons">
                    <i class="fa-regular fa-bell"></i>
                    <div class="avatar">A</div>
                </div>
            </header>

            <div class="content-area">
                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-boxes-stacked"></i> Algoritmo FEFO • Control de Caducidad</span>
                        <h2>Inventario de Lotes y Trazabilidad</h2>
                        <p>Gestión estricta de salida por proximidad de vencimiento (First Expire, First Out).</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalAjusteStock">
                            <i class="fa-solid fa-sliders"></i> Ajuste Manual de Lote
                        </button>
                    </div>
                </div>

                <!-- KPIs Dinámicos de Lotes -->
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="kpi-card">
                            <div class="kpi-header">Total de Lotes Registrados <i class="fa-solid fa-box text-success"></i></div>
                            <div class="kpi-value text-success">${listaLotes.size() > 0 ? listaLotes.size() : '0'}</div>
                            <div class="kpi-sub">Lotes ingresados por compras.</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="kpi-card">
                            <div class="kpi-header text-warning">Próximos a Vencer (< 60 días) <i class="fa-solid fa-triangle-exclamation text-warning"></i></div>
                            <div class="kpi-value text-dark">--</div>
                            <div class="kpi-sub">Requiere atención comercial o descuento.</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="kpi-card">
                            <div class="kpi-header text-danger">Lotes Agotados / Bloqueados <i class="fa-solid fa-ban text-danger"></i></div>
                            <div class="kpi-value text-dark">--</div>
                            <div class="kpi-sub">Stock en cero o retenido por caducidad.</div>
                        </div>
                    </div>
                </div>

                <!-- TABLA DE LOTES (Acorde a las 19 tablas de BD) -->
                <div class="table-card">
                    <table id="tablaInventario" class="table-custom">
                        <thead>
                            <tr>
                                <th>N° Lote</th>
                                <th>Medicamento Comercial</th>
                                <th>Ref. Compra</th>
                                <th>F. Vencimiento (FEFO)</th>
                                <th>Stock Inicial</th>
                                <th>Stock Actual</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="l" items="${listaLotes}">
                                <tr>
                                    <td><strong>${l.numeroLote}</strong></td>
                                    <td>
                                        <div style="line-height: 1.2;">
                                            <strong>${l.nombreMedicamento}</strong>
                                        </div>
                                    </td>
                                    <td><span class="text-muted"># CMP-${l.idCompra}</span></td>
                                    <td><span class="fw-bold text-dark">${l.fechaVencimiento}</span></td>
                                    <td>${l.stockInicial} unid.</td>
                                    <td>
                                        <strong class="${l.stockActual > 5 ? 'text-success' : 'text-danger'}">
                                            ${l.stockActual} unid.
                                        </strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${l.estado == 'DISPONIBLE'}">
                                                <span class="badge-ok"><i class="fa-solid fa-circle-check"></i> Activo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-vencido"><i class="fa-solid fa-ban"></i> ${l.estado}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-secondary" title="Ver Movimientos"><i class="fa-solid fa-eye"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Scripts DataTables y Bootstrap -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.2/js/buttons.print.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('#tablaInventario').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-3"Bf>rt<"d-flex justify-content-between mt-3"ip>',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa-solid fa-file-excel me-1"></i> Exportar Inventario',
                        className: 'btn btn-success text-white fw-bold shadow-sm border-0',
                        title: 'Inventario Lotes FEFO - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fa-solid fa-file-pdf me-1"></i> Reporte PDF',
                        className: 'btn btn-danger text-white fw-bold shadow-sm border-0 ms-2',
                        title: 'Inventario Lotes FEFO - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    }
                ],
                pageLength: 10
            });
        });
    </script>
</body>
</html>