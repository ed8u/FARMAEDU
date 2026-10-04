package pe.edu.utp.SistemaFarmaciaWeb.controlador;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import pe.edu.utp.SistemaFarmaciaWeb.dao.UsuarioDAO;
import pe.edu.utp.SistemaFarmaciaWeb.modelo.Usuario;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    private boolean esAdministrador(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuarioLogueado") != null) {
            Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
            return "ADMINISTRADOR".equalsIgnoreCase(u.getRol()) || "ADMIN".equalsIgnoreCase(u.getRol());
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdministrador(request)) {
            response.sendRedirect("DashboardServlet");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null || accion.equalsIgnoreCase("listar")) {
            List<Usuario> lista = dao.listarActivos();
            request.setAttribute("listaUsuarios", lista);
            request.getRequestDispatcher("/WEB-INF/views/usuarios.jsp").forward(request, response);

        } else if (accion.equalsIgnoreCase("eliminar")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminarLogico(id);
            } catch (NumberFormatException e) {
                System.err.println("Error ID Usuario inválido.");
            }
            response.sendRedirect("UsuarioServlet?accion=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        
        if (!esAdministrador(request)) {
            response.sendRedirect("DashboardServlet");
            return;
        }

        String accion = request.getParameter("accionForm");
        Usuario u = new Usuario();
        
        u.setNombresCompletos(request.getParameter("txtNombres"));
        u.setUsuario(request.getParameter("txtUsuario"));
        u.setPassword(request.getParameter("txtPassword"));
        u.setRol(request.getParameter("cboRol"));

        if ("Guardar".equalsIgnoreCase(accion)) {
            dao.registrar(u);
        } else if ("Actualizar".equalsIgnoreCase(accion)) {
            u.setIdUsuario(Integer.parseInt(request.getParameter("txtId")));
            dao.actualizar(u);
        }

        response.sendRedirect("UsuarioServlet?accion=listar");
    }
}
