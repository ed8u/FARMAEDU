-- ==============================================================================
-- SISTEMA ERP FARMAEDU / FARMACIAWI - ARQUITECTURA DE 19 TABLAS
-- ==============================================================================

-- 1. TABLA SEDES / SUCURSALES
CREATE TABLE Sedes (
    id_sede INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sede VARCHAR(100) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    telefono VARCHAR(15),
    estado BIT DEFAULT 1
);
GO

-- 2. TABLA CAJAS (Puntos de Venta)
CREATE TABLE Cajas (
    id_caja INT IDENTITY(1,1) PRIMARY KEY,
    id_sede INT NOT NULL,
    nombre_caja VARCHAR(50) NOT NULL,
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_sede) REFERENCES Sedes(id_sede)
);
GO

-- 3. TABLA TURNOS
CREATE TABLE Turnos (
    id_turno INT IDENTITY(1,1) PRIMARY KEY,
    nombre_turno VARCHAR(50) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL
);
GO

-- 4. TABLA USUARIOS (Personal de la Farmacia)
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    nombres_completos VARCHAR(150),
    estado BIT DEFAULT 1
);
GO

-- 5. TABLA CONTROL DE CAJA (Apertura y Cierre)
CREATE TABLE AperturaCierreCaja (
    id_apertura INT IDENTITY(1,1) PRIMARY KEY,
    id_caja INT NOT NULL,
    id_usuario INT NOT NULL,
    id_turno INT NOT NULL,
    fecha_apertura DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_cierre DATETIME,
    saldo_inicial DECIMAL(10,2) NOT NULL,
    saldo_final DECIMAL(10,2),
    estado VARCHAR(20) DEFAULT 'ABIERTA',
    FOREIGN KEY (id_caja) REFERENCES Cajas(id_caja),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_turno) REFERENCES Turnos(id_turno)
);
GO

-- 6. TABLA CLIENTES Y PACIENTES
CREATE TABLE Clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    dni_ruc VARCHAR(15) UNIQUE NOT NULL,
    nombres_rsocial VARCHAR(150) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    fecha_registro DATETIME DEFAULT GETDATE(),
    estado BIT DEFAULT 1
);
GO

-- 7. TABLA CATEGORÍAS (Clasificación Terapéutica)
CREATE TABLE Categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 8. TABLA LABORATORIOS
CREATE TABLE Laboratorios (
    id_laboratorio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_laboratorio VARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 9. TABLA PRINCIPIOS ACTIVOS (DCI)
CREATE TABLE PrincipiosActivos (
    id_principio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_principio VARCHAR(150) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 10. TABLA FORMAS FARMACÉUTICAS
CREATE TABLE FormasFarmaceuticas (
    id_forma INT IDENTITY(1,1) PRIMARY KEY,
    nombre_forma VARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 11. TABLA PRESENTACIONES (Empaques)
CREATE TABLE Presentaciones (
    id_presentacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre_presentacion VARCHAR(100) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 12. TABLA MAESTRA DE MEDICAMENTOS (Catálogo)
CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE,
    nombre_comercial VARCHAR(150) NOT NULL,
    id_principio INT NOT NULL,
    id_forma INT NOT NULL,
    concentracion VARCHAR(50),
    id_presentacion INT NOT NULL,
    id_laboratorio INT NOT NULL,
    id_categoria INT NOT NULL,
    precio_compra_ref DECIMAL(10,2),
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_minimo INT DEFAULT 10,
    receta_obligatoria BIT DEFAULT 0,
    estado BIT DEFAULT 1,
    FOREIGN KEY (id_principio) REFERENCES PrincipiosActivos(id_principio),
    FOREIGN KEY (id_forma) REFERENCES FormasFarmaceuticas(id_forma),
    FOREIGN KEY (id_presentacion) REFERENCES Presentaciones(id_presentacion),
    FOREIGN KEY (id_laboratorio) REFERENCES Laboratorios(id_laboratorio),
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);
GO

-- 13. TABLA PROVEEDORES
CREATE TABLE Proveedores (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    ruc VARCHAR(11) UNIQUE NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    email VARCHAR(100),
    estado BIT DEFAULT 1
);
GO

-- 14. TABLA COMPRAS (Ingresos de Mercadería)
CREATE TABLE Compras (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_usuario INT NOT NULL,
    numero_comprobante VARCHAR(50) NOT NULL,
    fecha_compra DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'COMPLETADO',
    FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);
GO

-- 15. TABLA DETALLE DE COMPRAS
CREATE TABLE DetalleCompras (
    id_detalle_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_compra INT NOT NULL,
    id_medicamento INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES Compras(id_compra),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);
GO

-- 16. TABLA DE LOTES E INVENTARIO (Sistema FEFO - First Expire, First Out)
CREATE TABLE Lotes (
    id_lote INT IDENTITY(1,1) PRIMARY KEY,
    id_medicamento INT NOT NULL,
    id_compra INT NOT NULL,
    numero_lote VARCHAR(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    stock_inicial INT NOT NULL,
    stock_actual INT NOT NULL,
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento),
    FOREIGN KEY (id_compra) REFERENCES Compras(id_compra)
);
GO

-- 17. TABLA MÉTODOS DE PAGO
CREATE TABLE MetodosPago (
    id_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL,
    estado BIT DEFAULT 1
);
GO

-- 18. TABLA VENTAS (POS)
CREATE TABLE Ventas (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_usuario INT NOT NULL,
    id_caja INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    numero_comprobante VARCHAR(50) NOT NULL UNIQUE,
    fecha_venta DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'EMITIDO',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_caja) REFERENCES Cajas(id_caja),
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodosPago(id_metodo_pago)
);
GO

-- 19. TABLA DETALLE DE VENTAS
CREATE TABLE DetalleVentas (
    id_detalle_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,
    id_medicamento INT NOT NULL,
    id_lote INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento),
    FOREIGN KEY (id_lote) REFERENCES Lotes(id_lote)
);
GO


-- ==============================================================================
-- INSERCIÓN DE DATOS DE PRUEBA (DATA SEMILLA PARA INICIAR EL SISTEMA)
-- ==============================================================================

-- Sedes, Cajas y Turnos
INSERT INTO Sedes (nombre_sede, direccion, telefono) VALUES ('Sede Central - San Isidro', 'Av. Javier Prado 1234', '01-555-1234');
GO
INSERT INTO Cajas (id_sede, nombre_caja) VALUES (1, 'Caja 01 - Mostrador Principal');
GO
INSERT INTO Turnos (nombre_turno, hora_inicio, hora_fin) VALUES ('Mañana', '07:00:00', '15:00:00'), ('Tarde', '15:00:00', '23:00:00');
GO

-- Usuario Administrador
INSERT INTO Usuarios (usuario, password, rol, nombres_completos) VALUES ('admin', 'admin123', 'Administrador', 'Carlos Mendoza - Regente');
GO

-- Métodos de Pago
INSERT INTO MetodosPago (nombre_metodo) VALUES ('Efectivo'), ('Tarjeta de Crédito/Débito'), ('Yape/Plin'), ('Transferencia Bancaria');
GO

-- Clientes
INSERT INTO Clientes (dni_ruc, nombres_rsocial, email, telefono, direccion)
VALUES 
('12345678', 'Cliente Público General', 'cliente@correo.com', '999888777', 'Lima'),
('20554918131', 'Clínica San Borja S.A.C.', 'contacto@clinica.com', '01-444555', 'San Borja');
GO

-- Datos Maestros de Medicamentos
INSERT INTO Categorias (nombre_categoria) VALUES ('Analgésicos'), ('Antibióticos'), ('Dermatológicos'), ('Cardiovasculares');
INSERT INTO Laboratorios (nombre_laboratorio) VALUES ('Bayer'), ('Genfar'), ('Farmindustria'), ('Pfizer');
INSERT INTO PrincipiosActivos (nombre_principio) VALUES ('Paracetamol'), ('Amoxicilina'), ('Ibuprofeno'), ('Losartán');
INSERT INTO FormasFarmaceuticas (nombre_forma) VALUES ('Tabletas'), ('Jarabe'), ('Inyectable'), ('Crema');
INSERT INTO Presentaciones (nombre_presentacion) VALUES ('Caja x 100'), ('Frasco 120ml'), ('Tubo 50g'), ('Blister x 10');
GO

-- Medicamentos Base
INSERT INTO Medicamentos (codigo_barras, nombre_comercial, id_principio, id_forma, concentracion, id_presentacion, id_laboratorio, id_categoria, precio_compra_ref, precio_venta, stock_minimo, receta_obligatoria)
VALUES 
('775123456789', 'Panadol Fuerte', 1, 1, '500mg', 1, 1, 1, 0.50, 1.20, 20, 0),
('775987654321', 'Amoxil', 2, 2, '250mg/5ml', 2, 2, 2, 12.00, 18.50, 5, 1);
GO

-- Proveedores
INSERT INTO Proveedores (ruc, razon_social, direccion, telefono, email)
VALUES ('20100020030', 'Droguería INKAFARMA S.A.', 'Av. Los Próceres 456', '01-666-7777', 'ventas@inkafarma.pe');
GO

-- Compra Base e Inventario Lote (Para probar FEFO en el Dashboard)
INSERT INTO Compras (id_proveedor, id_usuario, numero_comprobante, total) VALUES (1, 1, 'F001-00456', 220.00);
GO
INSERT INTO DetalleCompras (id_compra, id_medicamento, cantidad, precio_unitario, subtotal) 
VALUES (1, 1, 200, 0.50, 100.00), (1, 2, 10, 12.00, 120.00);
GO
INSERT INTO Lotes (id_medicamento, id_compra, numero_lote, fecha_vencimiento, stock_inicial, stock_actual)
VALUES 
(1, 1, 'LT-PAN-2024', '2025-12-31', 200, 200),
(2, 1, 'LT-AMX-2024', '2024-05-15', 10, 10); -- Lote próximo a vencer para probar alertas
GO