package controlador;

import dao.ClienteDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import modelo.Cliente;

@WebServlet(name = "ClienteServlet", urlPatterns = {"/ClienteServlet"})
public class ClienteServlet extends HttpServlet {

    private ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        if (accion == null || accion.equalsIgnoreCase("listar")) {
            List<Cliente> lista = dao.listarTodos();
            request.setAttribute("listaClientes", lista);
            request.getRequestDispatcher("clientes.jsp").forward(request, response);
            
        } else if (accion.equalsIgnoreCase("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.eliminar(id);
            response.sendRedirect("ClienteServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accionForm");
        
        Cliente c = new Cliente();
        
        // Capturamos los datos enviados por los Modals
        c.setDniRuc(request.getParameter("txtDniRuc"));
        c.setNombresRsocial(request.getParameter("txtNombres"));
        c.setEmail(request.getParameter("txtEmail"));
        c.setTelefono(request.getParameter("txtTelefono"));
        c.setDireccion(request.getParameter("txtDireccion"));
        
        if (accion != null && accion.equalsIgnoreCase("Guardar")) {
            dao.registrar(c);
        } else if (accion != null && accion.equalsIgnoreCase("Actualizar")) {
            c.setIdCliente(Integer.parseInt(request.getParameter("txtId")));
            dao.actualizar(c);
        }
        
        response.sendRedirect("ClienteServlet?accion=listar");
    }
}