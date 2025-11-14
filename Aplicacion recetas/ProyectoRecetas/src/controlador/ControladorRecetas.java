package controlador;

import dao.*;
import modelo.*;
import vista.VistaPrincipal;
import javax.swing.*;
import java.util.List;

/**
 * Controlador principal del sistema MVC
 * Con soporte para imágenes y favoritos
 */
public class ControladorRecetas {

    private RecetaDAO recetaDAO;
    private CategoriaDAO categoriaDAO;
    private IngredienteDAO ingredienteDAO;
    private UsuarioDAO usuarioDAO;
    private FavoritoDAO favoritoDAO;
    private VistaPrincipal vista;

    private Usuario usuarioActual = null;

    /**
     * Constructor
     */
    public ControladorRecetas(VistaPrincipal vista) {
        this.vista = vista;
        this.recetaDAO = new RecetaDAO();
        this.categoriaDAO = new CategoriaDAO();
        this.ingredienteDAO = new IngredienteDAO();
        this.usuarioDAO = new UsuarioDAO();
        this.favoritoDAO = new FavoritoDAO();
    }

    // ============= USUARIO ACTUAL =============

    public Usuario getUsuarioActual() {
        return usuarioActual;
    }

    public void setUsuarioActual(Usuario usuario) {
        this.usuarioActual = usuario;
        System.out.println("👤 Usuario actual: " + (usuario != null ? usuario.getNombre() : "Ninguno"));
    }

    // ============= USUARIOS =============

    public List<Usuario> obtenerTodosUsuarios() {
        try {
            return usuarioDAO.obtenerTodos();
        } catch (Exception e) {
            mostrarError("Error al obtener usuarios: " + e.getMessage());
            return null;
        }
    }

    public Usuario obtenerUsuarioPorId(int id) {
        try {
            return usuarioDAO.obtenerPorId(id);
        } catch (Exception e) {
            mostrarError("Error al obtener usuario: " + e.getMessage());
            return null;
        }
    }

    public boolean crearUsuario(String nombre, String correo, String contrasena, String rol) {
        try {
            if (nombre.isEmpty() || correo.isEmpty()) {
                mostrarError("Los campos obligatorios no pueden estar vacíos");
                return false;
            }

            Usuario usuario = new Usuario();
            usuario.setNombre(nombre);
            usuario.setCorreo(correo);
            usuario.setContrasena(contrasena.isEmpty() ? "123456" : contrasena);
            usuario.setRol(rol);

            if (usuarioDAO.crear(usuario)) {
                mostrarExito("Usuario creado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al crear usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarUsuario(int id, String nombre, String correo, String rol) {
        try {
            if (nombre.isEmpty() || correo.isEmpty()) {
                mostrarError("Los campos obligatorios no pueden estar vacíos");
                return false;
            }

            Usuario usuario = new Usuario();
            usuario.setIdUsuario(id);
            usuario.setNombre(nombre);
            usuario.setCorreo(correo);
            usuario.setRol(rol);

            if (usuarioDAO.actualizar(usuario)) {
                mostrarExito("Usuario actualizado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al actualizar usuario: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarUsuario(int id) {
        try {
            if (usuarioDAO.eliminar(id)) {
                mostrarExito("Usuario eliminado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }

    // ============= RECETAS =============

    public List<Receta> obtenerTodasRecetas() {
        try {
            if (usuarioActual == null) {
                mostrarError("Debes seleccionar un usuario primero");
                return null;
            }
            return recetaDAO.obtenerTodas();
        } catch (Exception e) {
            mostrarError("Error al obtener recetas: " + e.getMessage());
            return null;
        }
    }

    public Receta obtenerRecetaPorId(int id) {
        try {
            return recetaDAO.obtenerPorId(id);
        } catch (Exception e) {
            mostrarError("Error al obtener receta: " + e.getMessage());
            return null;
        }
    }

    public boolean crearReceta(String titulo, String descripcion, int tiempoPrep, 
                               String dificultad, int idCategoria) {
        try {
            if (usuarioActual == null) {
                mostrarError("Debes seleccionar un usuario primero");
                return false;
            }

            if (titulo.isEmpty() || descripcion.isEmpty()) {
                mostrarError("Los campos obligatorios no pueden estar vacíos");
                return false;
            }

            Receta receta = new Receta();
            receta.setTitulo(titulo);
            receta.setDescripcion(descripcion);
            receta.setTiempoPreparacion(tiempoPrep);
            receta.setDificultad(dificultad);
            receta.setIdUsuario(usuarioActual.getIdUsuario());
            receta.setIdCategoria(idCategoria);

            if (recetaDAO.crear(receta)) {
                mostrarExito("Receta creada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al crear receta: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarReceta(int id, String titulo, String descripcion, 
                                    int tiempoPrep, String dificultad, int idCategoria) {
        try {
            if (titulo.isEmpty() || descripcion.isEmpty()) {
                mostrarError("Los campos obligatorios no pueden estar vacíos");
                return false;
            }

            Receta receta = new Receta();
            receta.setIdReceta(id);
            receta.setTitulo(titulo);
            receta.setDescripcion(descripcion);
            receta.setTiempoPreparacion(tiempoPrep);
            receta.setDificultad(dificultad);
            receta.setIdCategoria(idCategoria);

            if (recetaDAO.actualizar(receta)) {
                mostrarExito("Receta actualizada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al actualizar receta: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarReceta(int idReceta) {
        try {
            if (recetaDAO.eliminar(idReceta)) {
                mostrarExito("Receta eliminada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al eliminar receta: " + e.getMessage());
            return false;
        }
    }

    // ============= IMÁGENES =============

    public String obtenerImagenReceta(int idReceta) {
        try {
            return recetaDAO.obtenerImagenReceta(idReceta);
        } catch (Exception e) {
            System.err.println("❌ Error al obtener imagen: " + e.getMessage());
            return null;
        }
    }

    public boolean guardarImagenReceta(int idReceta, String rutaImagen) {
        try {
            if (recetaDAO.guardarImagen(idReceta, rutaImagen)) {
                mostrarExito("Imagen guardada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al guardar imagen: " + e.getMessage());
            return false;
        }
    }

    // ============= FAVORITOS =============

    public List<Integer> obtenerFavoritosUsuario() {
        try {
            if (usuarioActual == null) {
                return new java.util.ArrayList<>();
            }
            return favoritoDAO.obtenerFavoritosUsuario(usuarioActual.getIdUsuario());
        } catch (Exception e) {
            System.err.println("❌ Error al obtener favoritos: " + e.getMessage());
            return new java.util.ArrayList<>();
        }
    }

    public boolean esFavorito(int idReceta) {
        try {
            if (usuarioActual == null) {
                return false;
            }
            return favoritoDAO.esFavorito(usuarioActual.getIdUsuario(), idReceta);
        } catch (Exception e) {
            return false;
        }
    }

    public boolean agregarFavorito(int idReceta) {
        try {
            if (usuarioActual == null) {
                mostrarError("Debes seleccionar un usuario primero");
                return false;
            }

            if (favoritoDAO.agregar(usuarioActual.getIdUsuario(), idReceta)) {
                mostrarExito("Agregado a favoritos ⭐");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al agregar favorito: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarFavorito(int idReceta) {
        try {
            if (usuarioActual == null) {
                return false;
            }

            if (favoritoDAO.eliminar(usuarioActual.getIdUsuario(), idReceta)) {
                mostrarExito("Eliminado de favoritos");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al eliminar favorito: " + e.getMessage());
            return false;
        }
    }

    // ============= CATEGORÍAS =============

    public List<Categoria> obtenerTodasCategorias() {
        try {
            return categoriaDAO.obtenerTodas();
        } catch (Exception e) {
            mostrarError("Error al obtener categorías: " + e.getMessage());
            return null;
        }
    }

    public Categoria obtenerCategoriaPorId(int id) {
        try {
            return categoriaDAO.obtenerPorId(id);
        } catch (Exception e) {
            mostrarError("Error al obtener categoría: " + e.getMessage());
            return null;
        }
    }

    public boolean crearCategoria(String nombre, String descripcion) {
        try {
            if (nombre.isEmpty()) {
                mostrarError("El nombre de la categoría es obligatorio");
                return false;
            }

            Categoria categoria = new Categoria();
            categoria.setNombre(nombre);
            categoria.setDescripcion(descripcion);

            if (categoriaDAO.crear(categoria)) {
                mostrarExito("Categoría creada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al crear categoría: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarCategoria(int id, String nombre, String descripcion) {
        try {
            if (nombre.isEmpty()) {
                mostrarError("El nombre de la categoría es obligatorio");
                return false;
            }

            Categoria categoria = new Categoria();
            categoria.setIdCategoria(id);
            categoria.setNombre(nombre);
            categoria.setDescripcion(descripcion);

            if (categoriaDAO.actualizar(categoria)) {
                mostrarExito("Categoría actualizada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al actualizar categoría: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarCategoria(int id) {
        try {
            if (categoriaDAO.eliminar(id)) {
                mostrarExito("Categoría eliminada exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al eliminar categoría: " + e.getMessage());
            return false;
        }
    }

    // ============= INGREDIENTES =============

    public List<Ingrediente> obtenerTodosIngredientes() {
        try {
            return ingredienteDAO.obtenerTodos();
        } catch (Exception e) {
            mostrarError("Error al obtener ingredientes: " + e.getMessage());
            return null;
        }
    }

    public Ingrediente obtenerIngredientePorId(int id) {
        try {
            return ingredienteDAO.obtenerPorId(id);
        } catch (Exception e) {
            mostrarError("Error al obtener ingrediente: " + e.getMessage());
            return null;
        }
    }

    public boolean crearIngrediente(String nombre, String unidad) {
        try {
            if (nombre.isEmpty()) {
                mostrarError("El nombre del ingrediente es obligatorio");
                return false;
            }

            Ingrediente ingrediente = new Ingrediente();
            ingrediente.setNombre(nombre);
            ingrediente.setUnidadMedida(unidad);

            if (ingredienteDAO.crear(ingrediente)) {
                mostrarExito("Ingrediente creado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al crear ingrediente: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarIngrediente(int id, String nombre, String unidad) {
        try {
            if (nombre.isEmpty()) {
                mostrarError("El nombre del ingrediente es obligatorio");
                return false;
            }

            Ingrediente ingrediente = new Ingrediente();
            ingrediente.setIdIngrediente(id);
            ingrediente.setNombre(nombre);
            ingrediente.setUnidadMedida(unidad);

            if (ingredienteDAO.actualizar(ingrediente)) {
                mostrarExito("Ingrediente actualizado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al actualizar ingrediente: " + e.getMessage());
            return false;
        }
    }

    public boolean eliminarIngrediente(int id) {
        try {
            if (ingredienteDAO.eliminar(id)) {
                mostrarExito("Ingrediente eliminado exitosamente");
                return true;
            }
            return false;
        } catch (Exception e) {
            mostrarError("Error al eliminar ingrediente: " + e.getMessage());
            return false;
        }
    }

    // ============= MENSAJES =============

    private void mostrarError(String mensaje) {
        JOptionPane.showMessageDialog(vista, mensaje, "❌ Error", JOptionPane.ERROR_MESSAGE);
    }

    private void mostrarExito(String mensaje) {
        JOptionPane.showMessageDialog(vista, mensaje, "✅ Éxito", JOptionPane.INFORMATION_MESSAGE);
    }
}