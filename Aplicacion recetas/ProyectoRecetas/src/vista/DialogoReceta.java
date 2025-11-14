package vista;

import controlador.ControladorRecetas;
import modelo.*;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.*;
import java.io.File;
import java.util.List;

/**
 * Diálogo para crear/editar recetas con carga de imagen
 */
public class DialogoReceta extends JDialog {

    private ControladorRecetas controlador;
    private Receta recetaEditar;

    private JTextField txtTitulo;
    private JTextArea txtDescripcion;
    private JSpinner spinTiempo;
    private JComboBox<String> comboDificultad;
    private JComboBox<Categoria> comboCategoria;
    private JLabel lblImagen;
    private JButton btnCargarImagen;
    private JButton btnGuardar;
    private JButton btnCancelar;

    private String rutaImagenSeleccionada = null;

    public DialogoReceta(Frame owner, ControladorRecetas controlador, Receta receta) {
        super(owner, true);
        this.controlador = controlador;
        this.recetaEditar = receta;

        initComponents();
    }

    private void initComponents() {
        setTitle(recetaEditar == null ? "Nueva Receta" : "Editar Receta");
        setSize(550, 600);
        setLocationRelativeTo(getOwner());
        setDefaultCloseOperation(JDialog.DISPOSE_ON_CLOSE);

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // Título
        gbc.gridx = 0; gbc.gridy = 0;
        mainPanel.add(new JLabel("Título:"), gbc);
        txtTitulo = new JTextField(20);
        gbc.gridx = 1;
        mainPanel.add(txtTitulo, gbc);

        // Descripción
        gbc.gridx = 0; gbc.gridy = 1;
        mainPanel.add(new JLabel("Descripción:"), gbc);
        txtDescripcion = new JTextArea(3, 20);
        txtDescripcion.setLineWrap(true);
        JScrollPane scrollDesc = new JScrollPane(txtDescripcion);
        gbc.gridx = 1;
        gbc.weighty = 0.5;
        mainPanel.add(scrollDesc, gbc);
        gbc.weighty = 0;

        // Tiempo
        gbc.gridx = 0; gbc.gridy = 2;
        mainPanel.add(new JLabel("Tiempo (min):"), gbc);
        spinTiempo = new JSpinner(new SpinnerNumberModel(30, 0, 480, 1));
        gbc.gridx = 1;
        mainPanel.add(spinTiempo, gbc);

        // Dificultad
        gbc.gridx = 0; gbc.gridy = 3;
        mainPanel.add(new JLabel("Dificultad:"), gbc);
        comboDificultad = new JComboBox<>(new String[]{"Fácil", "Media", "Difícil"});
        gbc.gridx = 1;
        mainPanel.add(comboDificultad, gbc);

        // Categoría
        gbc.gridx = 0; gbc.gridy = 4;
        mainPanel.add(new JLabel("Categoría:"), gbc);

        comboCategoria = new JComboBox<>();
        List<Categoria> categorias = controlador.obtenerTodasCategorias();
        if (categorias != null) {
            for (Categoria c : categorias) {
                comboCategoria.addItem(c);
            }
        }
        gbc.gridx = 1;
        mainPanel.add(comboCategoria, gbc);

        // Imagen
        gbc.gridx = 0; gbc.gridy = 5;
        mainPanel.add(new JLabel("Imagen:"), gbc);

        JPanel panelImagen = new JPanel(new BorderLayout(5, 5));
        lblImagen = new JLabel("📷 Sin imagen");
        lblImagen.setHorizontalAlignment(JLabel.CENTER);
        lblImagen.setPreferredSize(new Dimension(300, 150));
        lblImagen.setBorder(BorderFactory.createLineBorder(Color.GRAY));
        panelImagen.add(lblImagen, BorderLayout.CENTER);

        btnCargarImagen = new JButton("📤 Cargar Imagen");
        btnCargarImagen.addActionListener(e -> cargarImagen());
        panelImagen.add(btnCargarImagen, BorderLayout.SOUTH);

        gbc.gridx = 1;
        mainPanel.add(panelImagen, gbc);

        // Botones
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnGuardar = new JButton("Guardar");
        btnGuardar.addActionListener(e -> guardar());
        btnCancelar = new JButton("Cancelar");
        btnCancelar.addActionListener(e -> dispose());
        panelBotones.add(btnGuardar);
        panelBotones.add(btnCancelar);

        gbc.gridx = 0; gbc.gridy = 6;
        gbc.gridwidth = 2;
        mainPanel.add(panelBotones, gbc);

        // Cargar datos si es edición
        if (recetaEditar != null) {
            txtTitulo.setText(recetaEditar.getTitulo());
            txtDescripcion.setText(recetaEditar.getDescripcion());
            spinTiempo.setValue(recetaEditar.getTiempoPreparacion());
            comboDificultad.setSelectedItem(recetaEditar.getDificultad());

            // Cargar imagen si existe
            String rutaImg = controlador.obtenerImagenReceta(recetaEditar.getIdReceta());
            if (rutaImg != null) {
                mostrarImagenPrevia(new File(rutaImg));
            }
        }

        add(new JScrollPane(mainPanel));
    }

    private void cargarImagen() {
        JFileChooser fileChooser = new JFileChooser();
        FileNameExtensionFilter filter = new FileNameExtensionFilter(
            "Imágenes (JPG, PNG, GIF)", "jpg", "jpeg", "png", "gif");
        fileChooser.setFileFilter(filter);

        int result = fileChooser.showOpenDialog(this);
        if (result == JFileChooser.APPROVE_OPTION) {
            File archivoSeleccionado = fileChooser.getSelectedFile();
            rutaImagenSeleccionada = archivoSeleccionado.getAbsolutePath();
            mostrarImagenPrevia(archivoSeleccionado);
        }
    }

    private void mostrarImagenPrevia(File archivo) {
        try {
            ImageIcon icon = new ImageIcon(archivo.getAbsolutePath());
            Image img = icon.getImage().getScaledInstance(300, 150, Image.SCALE_SMOOTH);
            lblImagen.setIcon(new ImageIcon(img));
            lblImagen.setText("");
        } catch (Exception e) {
            lblImagen.setText("❌ Error al cargar imagen");
        }
    }

    private void guardar() {
        String titulo = txtTitulo.getText();
        String descripcion = txtDescripcion.getText();
        int tiempo = (Integer) spinTiempo.getValue();
        String dificultad = (String) comboDificultad.getSelectedItem();
        Categoria categoria = (Categoria) comboCategoria.getSelectedItem();

        if (titulo.isEmpty() || descripcion.isEmpty() || categoria == null) {
            JOptionPane.showMessageDialog(this,
                "❌ Completa todos los campos",
                "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        if (recetaEditar == null) {
            if (controlador.crearReceta(titulo, descripcion, tiempo, dificultad, categoria.getIdCategoria())) {
                // Guardar imagen si se seleccionó
                if (rutaImagenSeleccionada != null) {
                    // Obtener ID de la receta creada (simplificado)
                    List<Receta> recetas = controlador.obtenerTodasRecetas();
                    if (recetas != null && !recetas.isEmpty()) {
                        Receta ultimaReceta = recetas.get(0);
                        controlador.guardarImagenReceta(ultimaReceta.getIdReceta(), rutaImagenSeleccionada);
                    }
                }
                dispose();
            }
        } else {
            if (controlador.actualizarReceta(recetaEditar.getIdReceta(), titulo, descripcion,
                                             tiempo, dificultad, categoria.getIdCategoria())) {
                // Guardar imagen si se cambió
                if (rutaImagenSeleccionada != null) {
                    controlador.guardarImagenReceta(recetaEditar.getIdReceta(), rutaImagenSeleccionada);
                }
                dispose();
            }
        }
    }
}