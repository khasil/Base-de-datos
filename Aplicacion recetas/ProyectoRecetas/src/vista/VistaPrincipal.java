package vista;

import controlador.ControladorRecetas;
import modelo.*;
import util.DescargadorImagenes;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

/**
 * Vista Principal - VERSIÓN FINAL CON DESCARGA LOCAL
 * Imágenes se descargan una vez y se usan desde caché local
 */
public class VistaPrincipal extends JFrame {

    private ControladorRecetas controlador;
    private JTabbedPane tabbedPane;
    private JComboBox<Usuario> comboUsuarios;
    private JLabel lblUsuarioActual;

    // Componentes compartidos
    private JTable tablaUsuarios, tablaRecetas, tablaFavoritos, tablaImagenes;
    private JTable tablaCategorias, tablaIngredientes;
    private DefaultTableModel modeloTablaUsuarios, modeloTablaRecetas, modeloTablaFavoritos, modeloTablaImagenes;
    private DefaultTableModel modeloTablaCategorias, modeloTablaIngredientes;

    // Panel de imágenes
    private JLabel lblImagenReceta;

    // Botones
    private JButton btnNuevoUsuario, btnEditarUsuario, btnEliminarUsuario, btnSeleccionarUsuario, btnRefrescarUsuarios;
    private JButton btnNuevaReceta, btnEditarReceta, btnEliminarReceta, btnDetallesReceta, btnRefrescarRecetas;
    private JButton btnAgregarFavorito, btnVerDetallesFav, btnQuitarDelFav, btnRefrescarFav;
    private JButton btnVerImagen, btnCambiarImagen, btnRefrescarImagenes, btnVerEstadoCache;
    private JButton btnNuevaCategoria, btnEditarCategoria, btnEliminarCategoria, btnRefrescarCategorias;
    private JButton btnNuevoIngrediente, btnEditarIngrediente, btnEliminarIngrediente, btnRefrescarIngredientes;

    public VistaPrincipal() {
        // Mostrar estado del caché al iniciar
        System.out.println("\n🖼️ SISTEMA DE CACHÉ DE IMÁGENES INICIADO");
        DescargadorImagenes.mostrarEstadoCache();

        initComponents();
        setVisible(true);
    }

    private void initComponents() {
        setTitle("🍰 SISTEMA DE GESTIÓN DE RECETAS DE POSTRES 🍰");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1100, 750);
        setLocationRelativeTo(null);
        setResizable(true);

        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        JPanel panelSelector = crearPanelSelectorUsuario();
        mainPanel.add(panelSelector, BorderLayout.NORTH);

        tabbedPane = new JTabbedPane();
        tabbedPane.addTab("👤 Usuarios", crearPanelUsuarios());
        tabbedPane.addTab("📋 Recetas", crearPanelRecetas());
        tabbedPane.addTab("❤️ Mis Favoritos", crearPanelFavoritos());
        tabbedPane.addTab("🖼️ Imágenes", crearPanelImagenes());
        tabbedPane.addTab("📂 Categorías", crearPanelCategorias());
        tabbedPane.addTab("🥘 Ingredientes", crearPanelIngredientes());

        mainPanel.add(tabbedPane, BorderLayout.CENTER);
        add(mainPanel);

        controlador = new ControladorRecetas(this);

        cargarUsuarios();
        cargarRecetas();
        cargarCategorias();
        cargarIngredientes();
    }

    private JPanel crearPanelSelectorUsuario() {
        JPanel panel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        panel.setBorder(BorderFactory.createTitledBorder("═══ USUARIO ACTUAL ═══"));

        panel.add(new JLabel("Selecciona usuario:"));
        comboUsuarios = new JComboBox<>();
        comboUsuarios.addActionListener(e -> cambiarUsuarioActual());
        panel.add(comboUsuarios);

        lblUsuarioActual = new JLabel("❌ Sin usuario seleccionado");
        lblUsuarioActual.setFont(new Font("Arial", Font.BOLD, 12));
        lblUsuarioActual.setForeground(new Color(200, 0, 0));
        panel.add(lblUsuarioActual);

        return panel;
    }

    private void cambiarUsuarioActual() {
        Usuario usuario = (Usuario) comboUsuarios.getSelectedItem();
        if (usuario != null) {
            controlador.setUsuarioActual(usuario);
            lblUsuarioActual.setText("✅ Usuario: " + usuario.getNombre() + " (" + usuario.getRol() + ")");
            lblUsuarioActual.setForeground(new Color(0, 128, 0));
            cargarRecetas();
            cargarFavoritos();
        }
    }

    // ========== PANELES ==========

    private JPanel crearPanelUsuarios() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        modeloTablaUsuarios = new DefaultTableModel(new String[]{"ID", "Nombre", "Correo", "Rol"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaUsuarios = new JTable(modeloTablaUsuarios);
        panel.add(new JScrollPane(tablaUsuarios), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnNuevoUsuario = new JButton("➕ Nuevo"); btnNuevoUsuario.addActionListener(e -> { DialogoUsuario d = new DialogoUsuario(this, controlador, null); d.setVisible(true); cargarUsuarios(); });
        btnEditarUsuario = new JButton("✏️ Editar"); btnEditarUsuario.addActionListener(e -> editarUsuarioSeleccionado());
        btnEliminarUsuario = new JButton("🗑️ Eliminar"); btnEliminarUsuario.addActionListener(e -> eliminarUsuarioSeleccionado());
        btnSeleccionarUsuario = new JButton("✅ Seleccionar"); btnSeleccionarUsuario.addActionListener(e -> cambiarUsuarioActual());
        btnRefrescarUsuarios = new JButton("🔄 Refrescar"); btnRefrescarUsuarios.addActionListener(e -> cargarUsuarios());

        pb.add(btnNuevoUsuario); pb.add(btnEditarUsuario); pb.add(btnEliminarUsuario);
        pb.add(btnSeleccionarUsuario); pb.add(btnRefrescarUsuarios);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel crearPanelRecetas() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        modeloTablaRecetas = new DefaultTableModel(new String[]{"ID", "Título", "Categoría", "Dificultad", "Tiempo", "Usuario", "⭐"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaRecetas = new JTable(modeloTablaRecetas);
        panel.add(new JScrollPane(tablaRecetas), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnNuevaReceta = new JButton("➕ Nueva"); btnNuevaReceta.addActionListener(e -> { if(controlador.getUsuarioActual() == null) { JOptionPane.showMessageDialog(this, "Selecciona usuario"); return; } DialogoReceta d = new DialogoReceta(this, controlador, null); d.setVisible(true); cargarRecetas(); });
        btnEditarReceta = new JButton("✏️ Editar"); btnEditarReceta.addActionListener(e -> editarRecetaSeleccionada());
        btnDetallesReceta = new JButton("👁️ Detalles"); btnDetallesReceta.addActionListener(e -> mostrarDetallesReceta());
        btnAgregarFavorito = new JButton("⭐ Favorito"); btnAgregarFavorito.addActionListener(e -> agregarFavorito());
        btnEliminarReceta = new JButton("🗑️ Eliminar"); btnEliminarReceta.addActionListener(e -> eliminarRecetaSeleccionada());
        btnRefrescarRecetas = new JButton("🔄 Refrescar"); btnRefrescarRecetas.addActionListener(e -> cargarRecetas());

        pb.add(btnNuevaReceta); pb.add(btnEditarReceta); pb.add(btnDetallesReceta);
        pb.add(btnAgregarFavorito); pb.add(btnEliminarReceta); pb.add(btnRefrescarRecetas);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel crearPanelFavoritos() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        modeloTablaFavoritos = new DefaultTableModel(new String[]{"ID", "Título", "Categoría", "Dificultad", "Usuario"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaFavoritos = new JTable(modeloTablaFavoritos);
        panel.add(new JScrollPane(tablaFavoritos), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnVerDetallesFav = new JButton("👁️ Detalles"); btnVerDetallesFav.addActionListener(e -> mostrarDetallesFavorito());
        btnQuitarDelFav = new JButton("❌ Quitar"); btnQuitarDelFav.addActionListener(e -> quitarDelFavorito());
        btnRefrescarFav = new JButton("🔄 Refrescar"); btnRefrescarFav.addActionListener(e -> cargarFavoritos());

        pb.add(btnVerDetallesFav); pb.add(btnQuitarDelFav); pb.add(btnRefrescarFav);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel crearPanelImagenes() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Label con información
        lblImagenReceta = new JLabel("<html><center>📷 Selecciona una receta<br/><small>(Las imágenes se descargan y cachean localmente)</small></center></html>");
        lblImagenReceta.setHorizontalAlignment(JLabel.CENTER);
        lblImagenReceta.setPreferredSize(new Dimension(400, 300));
        lblImagenReceta.setBorder(BorderFactory.createLineBorder(Color.GRAY, 2));
        panel.add(new JScrollPane(lblImagenReceta), BorderLayout.NORTH);

        modeloTablaImagenes = new DefaultTableModel(new String[]{"ID", "Título", "Imagen"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaImagenes = new JTable(modeloTablaImagenes);
        tablaImagenes.getSelectionModel().addListSelectionListener(e -> mostrarImagenSeleccionada());
        panel.add(new JScrollPane(tablaImagenes), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnVerImagen = new JButton("👁️ Ver"); btnVerImagen.addActionListener(e -> mostrarImagenSeleccionada());
        btnCambiarImagen = new JButton("📤 Cambiar"); btnCambiarImagen.addActionListener(e -> cambiarImagenReceta());
        btnVerEstadoCache = new JButton("📊 Estado Caché"); btnVerEstadoCache.addActionListener(e -> DescargadorImagenes.mostrarEstadoCache());
        btnRefrescarImagenes = new JButton("🔄 Refrescar"); btnRefrescarImagenes.addActionListener(e -> cargarRecetas());

        pb.add(btnVerImagen); pb.add(btnCambiarImagen); pb.add(btnVerEstadoCache); pb.add(btnRefrescarImagenes);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel crearPanelCategorias() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        modeloTablaCategorias = new DefaultTableModel(new String[]{"ID", "Nombre", "Descripción"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaCategorias = new JTable(modeloTablaCategorias);
        panel.add(new JScrollPane(tablaCategorias), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnNuevaCategoria = new JButton("➕ Nueva"); btnNuevaCategoria.addActionListener(e -> { DialogoCategoria d = new DialogoCategoria(this, controlador, null); d.setVisible(true); cargarCategorias(); });
        btnEditarCategoria = new JButton("✏️ Editar"); btnEditarCategoria.addActionListener(e -> editarCategoriaSeleccionada());
        btnEliminarCategoria = new JButton("🗑️ Eliminar"); btnEliminarCategoria.addActionListener(e -> eliminarCategoriaSeleccionada());
        btnRefrescarCategorias = new JButton("🔄 Refrescar"); btnRefrescarCategorias.addActionListener(e -> cargarCategorias());

        pb.add(btnNuevaCategoria); pb.add(btnEditarCategoria);
        pb.add(btnEliminarCategoria); pb.add(btnRefrescarCategorias);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel crearPanelIngredientes() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        modeloTablaIngredientes = new DefaultTableModel(new String[]{"ID", "Nombre", "Unidad"}, 0) {
            public boolean isCellEditable(int r, int c) { return false; }
        };
        tablaIngredientes = new JTable(modeloTablaIngredientes);
        panel.add(new JScrollPane(tablaIngredientes), BorderLayout.CENTER);

        JPanel pb = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 10));
        btnNuevoIngrediente = new JButton("➕ Nuevo"); btnNuevoIngrediente.addActionListener(e -> { DialogoIngrediente d = new DialogoIngrediente(this, controlador, null); d.setVisible(true); cargarIngredientes(); });
        btnEditarIngrediente = new JButton("✏️ Editar"); btnEditarIngrediente.addActionListener(e -> editarIngredienteSeleccionado());
        btnEliminarIngrediente = new JButton("🗑️ Eliminar"); btnEliminarIngrediente.addActionListener(e -> eliminarIngredienteSeleccionado());
        btnRefrescarIngredientes = new JButton("🔄 Refrescar"); btnRefrescarIngredientes.addActionListener(e -> cargarIngredientes());

        pb.add(btnNuevoIngrediente); pb.add(btnEditarIngrediente);
        pb.add(btnEliminarIngrediente); pb.add(btnRefrescarIngredientes);
        panel.add(pb, BorderLayout.SOUTH);
        return panel;
    }

    // ========== CARGAR DATOS ==========

    private void cargarUsuarios() {
        modeloTablaUsuarios.setRowCount(0);
        List<Usuario> usuarios = controlador.obtenerTodosUsuarios();
        if (usuarios != null) {
            for (Usuario u : usuarios) {
                modeloTablaUsuarios.addRow(new Object[]{u.getIdUsuario(), u.getNombre(), u.getCorreo(), u.getRol()});
            }
            comboUsuarios.removeAllItems();
            for (Usuario u : usuarios) {
                comboUsuarios.addItem(u);
            }
        }
    }

    private void cargarRecetas() {
        modeloTablaRecetas.setRowCount(0);
        modeloTablaImagenes.setRowCount(0);
        List<Receta> recetas = controlador.obtenerTodasRecetas();
        List<Integer> favoritos = controlador.obtenerFavoritosUsuario();
        if (recetas != null) {
            for (Receta r : recetas) {
                String esFav = favoritos.contains(r.getIdReceta()) ? "⭐" : "☆";
                modeloTablaRecetas.addRow(new Object[]{r.getIdReceta(), r.getTitulo(), r.getNombreCategoria(), r.getDificultad(), r.getTiempoPreparacion(), r.getNombreUsuario(), esFav});
                String tieneImg = controlador.obtenerImagenReceta(r.getIdReceta()) != null ? "✅" : "❌";
                modeloTablaImagenes.addRow(new Object[]{r.getIdReceta(), r.getTitulo(), tieneImg});
            }
        }
    }

    private void cargarFavoritos() {
        modeloTablaFavoritos.setRowCount(0);
        List<Integer> favoritos = controlador.obtenerFavoritosUsuario();
        List<Receta> recetas = controlador.obtenerTodasRecetas();
        if (recetas != null) {
            for (Receta r : recetas) {
                if (favoritos.contains(r.getIdReceta())) {
                    modeloTablaFavoritos.addRow(new Object[]{r.getIdReceta(), r.getTitulo(), r.getNombreCategoria(), r.getDificultad(), r.getNombreUsuario()});
                }
            }
        }
    }

    private void cargarCategorias() {
        modeloTablaCategorias.setRowCount(0);
        List<Categoria> categorias = controlador.obtenerTodasCategorias();
        if (categorias != null) {
            for (Categoria c : categorias) {
                modeloTablaCategorias.addRow(new Object[]{c.getIdCategoria(), c.getNombre(), c.getDescripcion()});
            }
        }
    }

    private void cargarIngredientes() {
        modeloTablaIngredientes.setRowCount(0);
        List<Ingrediente> ingredientes = controlador.obtenerTodosIngredientes();
        if (ingredientes != null) {
            for (Ingrediente i : ingredientes) {
                modeloTablaIngredientes.addRow(new Object[]{i.getIdIngrediente(), i.getNombre(), i.getUnidadMedida()});
            }
        }
    }

    // ========== ACCIONES ==========

    private void editarUsuarioSeleccionado() {
        int fila = tablaUsuarios.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaUsuarios.getValueAt(fila, 0);
        DialogoUsuario d = new DialogoUsuario(this, controlador, controlador.obtenerUsuarioPorId(id));
        d.setVisible(true);
        cargarUsuarios();
    }

    private void eliminarUsuarioSeleccionado() {
        int fila = tablaUsuarios.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaUsuarios.getValueAt(fila, 0);
        String nombre = (String) modeloTablaUsuarios.getValueAt(fila, 1);
        if (JOptionPane.showConfirmDialog(this, "¿Eliminar: " + nombre + "?", "Confirmar", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (controlador.eliminarUsuario(id)) cargarUsuarios();
        }
    }

    private void editarRecetaSeleccionada() {
        int fila = tablaRecetas.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaRecetas.getValueAt(fila, 0);
        DialogoReceta d = new DialogoReceta(this, controlador, controlador.obtenerRecetaPorId(id));
        d.setVisible(true);
        cargarRecetas();
    }

    private void mostrarDetallesReceta() {
        int fila = tablaRecetas.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaRecetas.getValueAt(fila, 0);
        mostrarDetalles(controlador.obtenerRecetaPorId(id));
    }

    private void mostrarDetalles(Receta r) {
        StringBuilder sb = new StringBuilder("📋 " + r.getTitulo() + "\n\n");
        sb.append("Categoría: ").append(r.getNombreCategoria()).append("\n");
        sb.append("Dificultad: ").append(r.getDificultad()).append("\n");
        sb.append("Tiempo: ").append(r.getTiempoPreparacion()).append(" min\n\n");
        sb.append("Descripción:\n").append(r.getDescripcion());
        JTextArea ta = new JTextArea(sb.toString());
        ta.setEditable(false);
        ta.setLineWrap(true);
        JScrollPane sp = new JScrollPane(ta);
        sp.setPreferredSize(new java.awt.Dimension(500, 400));
        JOptionPane.showMessageDialog(this, sp, "Detalles", JOptionPane.INFORMATION_MESSAGE);
    }

    private void agregarFavorito() {
        int fila = tablaRecetas.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaRecetas.getValueAt(fila, 0);
        if (controlador.esFavorito(id)) {
            controlador.eliminarFavorito(id);
        } else {
            controlador.agregarFavorito(id);
        }
        cargarRecetas();
        cargarFavoritos();
    }

    private void eliminarRecetaSeleccionada() {
        int fila = tablaRecetas.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaRecetas.getValueAt(fila, 0);
        String titulo = (String) modeloTablaRecetas.getValueAt(fila, 1);
        if (JOptionPane.showConfirmDialog(this, "¿Eliminar: " + titulo + "?", "Confirmar", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (controlador.eliminarReceta(id)) cargarRecetas();
        }
    }

    private void mostrarDetallesFavorito() {
        int fila = tablaFavoritos.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaFavoritos.getValueAt(fila, 0);
        mostrarDetalles(controlador.obtenerRecetaPorId(id));
    }

    private void quitarDelFavorito() {
        int fila = tablaFavoritos.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaFavoritos.getValueAt(fila, 0);
        controlador.eliminarFavorito(id);
        cargarRecetas();
        cargarFavoritos();
    }

    private void mostrarImagenSeleccionada() {
        int fila = tablaImagenes.getSelectedRow();
        if (fila < 0) {
            lblImagenReceta.setIcon(null);
            lblImagenReceta.setText("📷 Selecciona una receta");
            return;
        }

        int id = (Integer) modeloTablaImagenes.getValueAt(fila, 0);
        String url = controlador.obtenerImagenReceta(id);

        if (url != null) {
            // Usar DescargadorImagenes en lugar de ManejadorImagen
            DescargadorImagenes.cargarImagenAsincrona(url, lblImagenReceta);
        } else {
            lblImagenReceta.setIcon(null);
            lblImagenReceta.setText("📷 Sin imagen");
        }
    }

    private void cambiarImagenReceta() {
        int fila = tablaImagenes.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaImagenes.getValueAt(fila, 0);
        DialogoReceta d = new DialogoReceta(this, controlador, controlador.obtenerRecetaPorId(id));
        d.setVisible(true);
        cargarRecetas();
    }

    private void editarCategoriaSeleccionada() {
        int fila = tablaCategorias.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaCategorias.getValueAt(fila, 0);
        DialogoCategoria d = new DialogoCategoria(this, controlador, controlador.obtenerCategoriaPorId(id));
        d.setVisible(true);
        cargarCategorias();
    }

    private void eliminarCategoriaSeleccionada() {
        int fila = tablaCategorias.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaCategorias.getValueAt(fila, 0);
        String nombre = (String) modeloTablaCategorias.getValueAt(fila, 1);
        if (JOptionPane.showConfirmDialog(this, "¿Eliminar: " + nombre + "?", "Confirmar", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (controlador.eliminarCategoria(id)) cargarCategorias();
        }
    }

    private void editarIngredienteSeleccionado() {
        int fila = tablaIngredientes.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaIngredientes.getValueAt(fila, 0);
        DialogoIngrediente d = new DialogoIngrediente(this, controlador, controlador.obtenerIngredientePorId(id));
        d.setVisible(true);
        cargarIngredientes();
    }

    private void eliminarIngredienteSeleccionado() {
        int fila = tablaIngredientes.getSelectedRow();
        if (fila < 0) return;
        int id = (Integer) modeloTablaIngredientes.getValueAt(fila, 0);
        String nombre = (String) modeloTablaIngredientes.getValueAt(fila, 1);
        if (JOptionPane.showConfirmDialog(this, "¿Eliminar: " + nombre + "?", "Confirmar", JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION) {
            if (controlador.eliminarIngrediente(id)) cargarIngredientes();
        }
    }
}