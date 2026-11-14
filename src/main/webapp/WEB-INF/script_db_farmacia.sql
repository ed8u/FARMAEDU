CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    nombres_completos NVARCHAR(150),
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    tipo_documento VARCHAR(10) NOT NULL DEFAULT 'DNI', 
    dni_ruc VARCHAR(15) UNIQUE NOT NULL,
    nombres_rsocial NVARCHAR(150) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion NVARCHAR(200),
    fecha_registro DATETIME NOT NULL DEFAULT GETDATE(),
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR(100) NOT NULL,
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Laboratorios (
    id_laboratorio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_laboratorio NVARCHAR(100) NOT NULL,
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE PrincipiosActivos (
    id_principio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_principio NVARCHAR(150) NOT NULL,
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE FormasFarmaceuticas (
    id_forma INT IDENTITY(1,1) PRIMARY KEY,
    nombre_forma NVARCHAR(100) NOT NULL, 
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Presentaciones (
    id_presentacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre_presentacion NVARCHAR(100) NOT NULL, 
    estado BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1) PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE,
    nombre_comercial NVARCHAR(150) NOT NULL,
    id_principio INT NOT NULL,
    id_forma INT NOT NULL,
    concentracion NVARCHAR(50), 
    id_presentacion INT NOT NULL,
    id_laboratorio INT NOT NULL,
    id_categoria INT NOT NULL,
    precio_compra_ref DECIMAL(10,2),
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_minimo INT NOT NULL DEFAULT 10,
    receta_obligatoria BIT NOT NULL DEFAULT 0,
    estado BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_principio) REFERENCES PrincipiosActivos(id_principio),
    FOREIGN KEY (id_forma) REFERENCES FormasFarmaceuticas(id_forma),
    FOREIGN KEY (id_presentacion) REFERENCES Presentaciones(id_presentacion),
    FOREIGN KEY (id_laboratorio) REFERENCES Laboratorios(id_laboratorio),
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
);
GO

CREATE TABLE LotesMedicamentos (
    id_lote INT IDENTITY(1,1) PRIMARY KEY,
    id_medicamento INT NOT NULL,
    numero_lote VARCHAR(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    stock_actual INT NOT NULL CHECK (stock_actual >= 0),
    fecha_ingreso DATETIME NOT NULL DEFAULT GETDATE(),
    estado BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
);
GO

CREATE TABLE Ventas (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,              
    id_usuario INT NOT NULL,              
    tipo_comprobante VARCHAR(20) NOT NULL, 
    numero_comprobante VARCHAR(20) UNIQUE NOT NULL, 
    fecha_venta DATETIME NOT NULL DEFAULT GETDATE(),
    subtotal DECIMAL(10,2) NOT NULL,     
    igv DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50) NOT NULL,     
    estado BIT NOT NULL DEFAULT 1,   
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);
GO

CREATE TABLE DetalleVentas (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    id_venta INT NOT NULL,                 
    id_medicamento INT NOT NULL,
    id_lote INT NOT NULL,   
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL, 
    FOREIGN KEY (id_venta) REFERENCES Ventas(id_venta),
    FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento),
    FOREIGN KEY (id_lote) REFERENCES LotesMedicamentos(id_lote)
);
GO

-- DATOS SEMILLA (Catálogos y Usuario Admin Inicial)
INSERT INTO Usuarios (usuario, password, rol, nombres_completos, estado) 
VALUES ('admin', '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'ADMINISTRADOR', 'Administrador General', 1);
GO
INSERT INTO Clientes (tipo_documento, dni_ruc, nombres_rsocial, direccion) 
VALUES ('DNI', '00000000', 'Público General', 'Chiclayo');
GO

INSERT INTO Categorias (nombre_categoria) VALUES ('Analgésicos'), ('Antibióticos'), ('Antiinflamatorios');
GO
INSERT INTO Laboratorios (nombre_laboratorio) VALUES ('Bayer'), ('Pfizer'), ('Genfar'), ('Farmindustria');
GO
INSERT INTO PrincipiosActivos (nombre_principio) VALUES ('Paracetamol'), ('Ibuprofeno'), ('Amoxicilina');
GO
INSERT INTO FormasFarmaceuticas (nombre_forma) VALUES ('Tableta'), ('Jarabe'), ('Cápsula'), ('Inyectable');
GO
INSERT INTO Presentaciones (nombre_presentacion) VALUES ('Caja x 20 tabletas'), ('Frasco x 120 ml'), ('Caja x 100 cápsulas');
GO