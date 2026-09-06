package controlador;

import config.ConexionDB;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Lote; // Asegúrate de tener o crear este JavaBean

@WebServlet(name = "InventarioServlet", urlPatterns = {"/InventarioServlet"})
public class InventarioServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listarLotes(request, response);
                break;
            default:
                listarLotes(request, response);
                break;
        }
    }

    private void listarLotes(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Lote> listaLotes = new ArrayList<>();
        String sql = "SELECT l.id_lote, l.numero_lote, m.nombre_comercial, l.id_compra, " +
                     "l.fecha_vencimiento, l.stock_inicial, l.stock_actual, l.estado " +
                     "FROM Lotes l INNER JOIN Medicamentos m ON l.id_medicamento = m.id_medicamento " +
                     "ORDER BY l.fecha_vencimiento ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Lote lote = new Lote();
                lote.setIdLote(rs.getInt("id_lote"));
                lote.setNumeroLote(rs.getString("numero_lote"));
                lote.setNomeMedicamento(rs.getString("nombre_comercial"));
                lote.setIdCompra(rs.getInt("id_compra"));
                lote.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
                lote.setStockInicial(rs.getInt("stock_inicial"));
                lote.setStockActual(rs.getInt("stock_actual"));
                lote.setEstado(rs.getString("estado"));
                
                listaLotes.add(lote);
            }
        } catch (Exception e) {
            System.out.println("Error al listar lotes FEFO: " + e.getMessage());
        }

        request.setAttribute("listaLotes", listaLotes);
        request.getRequestDispatcher("inventario.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}