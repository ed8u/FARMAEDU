<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Directorio de Clientes - FARMAEDU ERP</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome 6 -->
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

        body {
            background-color: var(--bg-body);
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            overflow: hidden; 
            color: #1e293b;
            height: 100vh;
            margin: 0;
        }

        .wrapper { display: flex; width: 100%; height: 100vh; }

        /* SIDEBAR COMPLETO */
        .sidebar {
            width: 260px;
            background-color: var(--bg-sidebar); 
            color: #a7f3d0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }
        .sidebar-header {
            padding: 20px; display: flex; align-items: center; gap: 12px; background-color: #012119;
        }
        .logo-box {
            width: 32px; height: 32px; border: 1px solid #10b981; color: #10b981;
            display: flex; align-items: center; justify-content: center; border-radius: 6px; font-weight: bold;
        }
        .sidebar-header h5 { margin: 0; color: #ffffff; font-weight: 800; font-size: 1.1rem; letter-spacing: 0.5px; }
        .sidebar-header small { display: block; font-size: 0.6rem; color: #6ee7b7; letter-spacing: 1px; text-transform: uppercase;}

        .sidebar-content { flex-grow: 1; overflow-y: auto; padding-top: 10px; }
        .sidebar-content::-webkit-scrollbar { display: none; }

        .sidebar-section {
            font-size: 0.65rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.5px; color: #059669; padding: 15px 20px 5px 20px; margin: 0;
        }

        .sidebar-menu { list-style: none; padding: 0 12px; margin: 0; }
        .sidebar-menu .nav-link {
            color: #d1fae5; display: flex; align-items: center; padding: 9px 15px;
            border-radius: 8px; font-size: 0.8rem; font-weight: 500; text-decoration: none;
            transition: all 0.2s; margin-bottom: 2px;
        }
        .sidebar-menu .nav-link i.icon-main { width: 25px; font-size: 0.95rem; }
        .sidebar-menu .nav-link:hover { background-color: var(--bg-sidebar-hover); color: #ffffff; }
        .sidebar-menu .nav-link.active { background-color: #047857; color: #ffffff; font-weight: 600;}

        .sidebar-footer {
            padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.05);
            display: flex; align-items: center; gap: 10px; background-color: #012119;
        }
        .sidebar-footer i { font-size: 1.5rem; color: #34d399; }
        .sidebar-footer div { line-height: 1.2; }
        .sidebar-footer span { font-size: 0.8rem; font-weight: 700; color: white; display: block;}
        .sidebar-footer small { font-size: 0.65rem; color: #6ee7b7; }
        .logout-btn { margin-left: auto; color: #94a3b8; cursor: pointer; }

        /* CONTENIDO PRINCIPAL */
        .main-content { flex-grow: 1; display: flex; flex-direction: column; height: 100vh; }

        .topbar {
            background-color: #ffffff; height: 55px; display: flex; justify-content: space-between;
            align-items: center; padding: 0 25px; border-bottom: 1px solid var(--border-color); flex-shrink: 0; font-size: 0.8rem;
        }
        .search-bar { display: flex; align-items: center; gap: 10px; width: 300px; color: var(--text-muted); }
        .search-bar input { border: none; outline: none; width: 100%; font-size: 0.85rem; }
        
        .topbar-info { display: flex; align-items: center; gap: 20px; font-weight: 500; color: #475569;}
        .topbar-icons .avatar {
            width: 28px; height: 28px; background: #0f172a; color: white; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center; font-size: 0.75rem; margin-left: 15px; font-weight: bold;
        }

        .content-area {
            padding: 24px 30px; overflow-y: auto; height: calc(100vh - 55px); background-color: #f1f5f9;
        }

        .page-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .page-title span { font-size: 0.65rem; font-weight: 700; color: var(--primary-color); letter-spacing: 1px; text-transform: uppercase;}
        .page-title h2 { font-weight: 800; font-size: 1.6rem; margin: 4px 0; color: #0f172a; letter-spacing: -0.5px;}
        .page-title p { color: var(--text-muted); font-size: 0.85rem; margin: 0; }
        
        .header-actions { display: flex; gap: 10px; }
        .btn-action {
            background: white; border: 1px solid var(--border-color); padding: 8px 15px;
            border-radius: 6px; font-size: 0.8rem; font-weight: 600; color: #334155; display: flex; align-items: center; gap: 8px;
        }
        .btn-primary-custom { background: var(--primary-color); border: none; color: white; }

        .kpi-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); display: flex; flex-direction: column; justify-content: space-between; height: 100%;}
        .kpi-header { display: flex; justify-content: space-between; font-size: 0.7rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase;}
        .kpi-header i { font-size: 1rem; color: #94a3b8; }
        .kpi-value { font-size: 1.8rem; font-weight: 800; color: #0f172a; margin: 10px 0 5px 0;}
        .kpi-sub { font-size: 0.75rem; color: var(--text-muted); line-height: 1.3;}

        .table-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid var(--border-color); margin-top: 24px;}
        
        .client-avatar {
            width: 35px; height: 35px; background: #0f172a; color: white; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center; font-size: 0.8rem; font-weight: bold; margin-right: 12px;
        }
        .client-info { display: inline-block; vertical-align: middle; line-height: 1.2;}
        .client-info strong { color: #0f172a; font-size: 0.85rem;}
        .client-info small { color: var(--text-muted); font-size: 0.75rem; display: block;}

        .table-custom { width: 100%; font-size: 0.85rem;}
        .table-custom th { font-size: 0.7rem; color: var(--text-muted); text-transform: uppercase; font-weight: 700; border-bottom: 1px solid var(--border-color); padding-bottom: 10px;}
        .table-custom td { padding: 12px 10px; border-bottom: 1px solid #f1f5f9; vertical-align: middle;}
        
        .action-btns i { cursor: pointer; color: #64748b; font-size: 1rem; margin-right: 10px; transition: color 0.2s;}
        .action-btns i:hover { color: var(--primary-color); }
        .action-btns .btn-del:hover { color: #ef4444; }

        /* Ajustes DataTables */
        .dataTables_wrapper .dataTables_filter input { border: 1px solid #e2e8f0; border-radius: 6px; padding: 4px 10px; margin-left: 10px; outline: none;}
        .dt-buttons .btn { margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="wrapper">
        
        <!-- SIDEBAR COMPLETO Y CORREGIDO -->
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
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-boxes-stacked icon-main"></i> Inventario & Lotes (FEFO)</a></li>
                    <li class="nav-item"><a href="#" class="nav-link"><i class="fa-solid fa-truck-ramp-box icon-main"></i> Compras y Proveedores</a></li>
                    <li class="nav-item"><a href="MedicamentoServlet?accion=listar" class="nav-link"><i class="fa-solid fa-book-medical icon-main"></i> Catálogo Maestro</a></li>
                    <li class="nav-item"><a href="ClienteServlet?accion=listar" class="nav-link active"><i class="fa-solid fa-users icon-main"></i> Clientes y Pacientes</a></li>
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
                    <input type="text" placeholder="Búsqueda rápida en todo el ERP...">
                </div>
                <div class="topbar-info">
                    <span><i class="fa-solid fa-store me-1 text-success"></i> Sucursal Principal</span>
                    <span><i class="fa-regular fa-clock me-1 text-success"></i> Turno Mañana (Caja 01)</span>
                </div>
                <div class="topbar-icons">
                    <i class="fa-regular fa-bell"></i>
                    <div class="avatar">A</div>
                </div>
            </header>

            <div class="content-area">
                
                <div class="page-header">
                    <div class="page-title">
                        <span><i class="fa-solid fa-id-card"></i> Farma-Edu • v1.0 </span>
                        <h2>Directorio de Clientes & Pacientes</h2>
                        <p>Ver que poner aquiiiiii</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-action btn-primary-custom" data-bs-toggle="modal" data-bs-target="#modalNuevoCliente">
                            <i class="fa-solid fa-user-plus"></i> + Nuevo Cliente / Paciente
                        </button>
                    </div>
                </div>

                <!-- Lógica JSTL para contar dinámicamente DNI y RUC sin tocar el Backend -->
                <c:set var="countDNI" value="0" />
                <c:set var="countRUC" value="0" />
                <c:forEach var="c" items="${listaClientes}">
                    <c:if test="${c.dniRuc.length() == 11}">
                        <c:set var="countRUC" value="${countRUC + 1}" />
                    </c:if>
                    <c:if test="${c.dniRuc.length() != 11}">
                        <c:set var="countDNI" value="${countDNI + 1}" />
                    </c:if>
                </c:forEach>

                <div class="row g-3">
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Total Registrados <i class="fa-solid fa-users text-primary"></i></div>
                            <div class="kpi-value text-success">${listaClientes.size() > 0 ? listaClientes.size() : '0'}</div>
                            <div class="kpi-sub">Activos en base de datos.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Personas Naturales (DNI) <i class="fa-solid fa-user text-info"></i></div>
                            <!-- Inyecta la variable contada -->
                            <div class="kpi-value text-dark">${countDNI}</div>
                            <div class="kpi-sub">Clientes para Boleta Electrónica.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Empresas (RUC) <i class="fa-solid fa-building text-warning"></i></div>
                            <!-- Inyecta la variable contada -->
                            <div class="kpi-value text-dark">${countRUC}</div>
                            <div class="kpi-sub">Clientes para Factura Electrónica.</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="kpi-card">
                            <div class="kpi-header">Integridad de Datos <i class="fa-solid fa-shield-check text-success"></i></div>
                            <div class="kpi-value text-dark">100%</div>
                            <div class="kpi-sub">Listos para exportación.</div>
                        </div>
                    </div>
                </div>

                <div class="table-card">
                    <table id="tablaClientes" class="table-custom">
                        <thead>
                            <tr>
                                <th>Identificación / Doc</th>
                                <th>Paciente / Razón Social</th>
                                <th>Contacto (Email / Tel)</th>
                                <th>Dirección</th>
                                <th>Acciones Clínicas</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${listaClientes}">
                                <tr>
                                    <td>
                                        <strong>${c.dniRuc}</strong><br>
                                        <small class="text-muted">${c.dniRuc.length() == 11 ? 'RUC Jurídico' : 'DNI Natural'}</small>
                                    </td>
                                    <td>
                                        <div class="client-avatar bg-success">${c.nombresRsocial.substring(0,1).toUpperCase()}</div>
                                        <div class="client-info">
                                            <strong>${c.nombresRsocial}</strong>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="client-info">
                                            <strong>${c.telefono}</strong><br>
                                            <small>${c.email}</small>
                                        </div>
                                    </td>
                                    <td><span class="text-muted" style="font-size: 0.75rem;">${c.direccion}</span></td>
                                    <td class="action-btns">
                                        <i class="fa-solid fa-pen" title="Editar" 
                                           onclick="abrirModalEditar('${c.idCliente}', '${c.dniRuc}', '${c.nombresRsocial}', '${c.email}', '${c.telefono}', '${c.direccion}')"></i>
                                        
                                        <a href="ClienteServlet?accion=eliminar&id=${c.idCliente}" class="btn-del" onclick="return confirm('¿Seguro de eliminar este registro?');">
                                            <i class="fa-solid fa-trash-can" title="Eliminar"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </main>
    </div>

    <!-- Modals (Nuevo y Editar) -->
    <div class="modal fade" id="modalNuevoCliente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-user-plus me-2"></i>Registrar Nuevo Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Guardar">
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">DNI o RUC:</label>
                            <input type="text" name="txtDniRuc" class="form-control" required maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Completo / Razón Social:</label>
                            <input type="text" name="txtNombres" class="form-control" required autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Correo Electrónico:</label>
                            <input type="email" name="txtEmail" class="form-control" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Teléfono:</label>
                            <input type="text" name="txtTelefono" class="form-control" maxlength="15" autocomplete="off">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Dirección:</label>
                            <input type="text" name="txtDireccion" class="form-control" autocomplete="off">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Guardar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalEditarCliente" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header text-white" style="background-color: #0f172a;">
                    <h5 class="modal-title fw-bold"><i class="fa-solid fa-pen me-2"></i>Editar Cliente</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="ClienteServlet" method="POST">
                    <div class="modal-body bg-light">
                        <input type="hidden" name="accionForm" value="Actualizar">
                        <input type="hidden" name="txtId" id="editId">
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">DNI o RUC:</label>
                            <input type="text" name="txtDniRuc" id="editDni" class="form-control" required maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Nombre Completo / Razón Social:</label>
                            <input type="text" name="txtNombres" id="editNombres" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Correo Electrónico:</label>
                            <input type="email" name="txtEmail" id="editEmail" class="form-control">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Teléfono:</label>
                            <input type="text" name="txtTelefono" id="editTelefono" class="form-control" maxlength="15">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold" style="font-size: 0.8rem;">Dirección:</label>
                            <input type="text" name="txtDireccion" id="editDireccion" class="form-control">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-dark fw-bold">Actualizar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts Esenciales -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Scripts DataTables -->
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
            $('#tablaClientes').DataTable({
                language: { url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json' },
                dom: '<"d-flex justify-content-between align-items-center mb-3"Bf>rt<"d-flex justify-content-between mt-3"ip>',
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa-solid fa-file-excel me-1"></i> Exportar a Excel',
                        className: 'btn btn-success text-white fw-bold shadow-sm border-0',
                        title: 'Directorio de Clientes - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    },
                    {
                        extend: 'pdfHtml5',
                        text: '<i class="fa-solid fa-file-pdf me-1"></i> Fichas PDF',
                        className: 'btn btn-danger text-white fw-bold shadow-sm border-0 ms-2',
                        title: 'Directorio de Clientes - FARMAEDU',
                        init: function(api, node, config) { $(node).removeClass('btn-secondary'); }
                    }
                ],
                pageLength: 10
            });
        });

        function abrirModalEditar(id, dni, nombres, email, tel, dir) {
            document.getElementById('editId').value = id;
            document.getElementById('editDni').value = dni;
            document.getElementById('editNombres').value = nombres;
            document.getElementById('editEmail').value = email;
            document.getElementById('editTelefono').value = tel;
            document.getElementById('editDireccion').value = dir;
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarCliente'));
            myModal.show();
        }
    </script>
</body>
</html>