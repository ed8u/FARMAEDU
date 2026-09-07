package pe.edu.utp.SistemaFarmaciaWeb.config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    // Asegúrate de que las credenciales coincidan con las de tu Inicializador
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=FarmaciaWI;encrypt=false;trustServerCertificate=true;";
    private static final String USER = "sa";
    private static final String PASS = "123456";

    public static Connection getConexion() {
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: No se encontró el driver JDBC de SQL Server.");
        } catch (SQLException e) {
            System.err.println("Error de conexión a la Base de Datos: " + e.getMessage());
        }
        return con;
    }
}