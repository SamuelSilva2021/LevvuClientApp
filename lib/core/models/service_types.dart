enum EServiceTypes {
  // Categoria: Mudança Completa
  residentialMoving(
      'Mudança Residencial',
      'Mudança completa de residência ou escritório',
      'home_work_outlined',
      ServiceCategory.moving),
  commercialMoving(
      'Mudança Comercial',
      'Mudança de escritório ou estabelecimento comercial',
      'business_outlined',
      ServiceCategory.moving),

  // Categoria: Transporte de Móveis
  furnitureSofa(
      'Sofás e Poltronas',
      'Transporte de sofás, poltronas e estofados',
      'chair_outlined',
      ServiceCategory.furniture),
  furnitureBed('Camas e Colchões', 'Transporte de camas, colchões e bases',
      'bed_outlined', ServiceCategory.furniture),
  furnitureWardrobe(
      'Estantes e Armários',
      'Transporte de estantes, armários e guarda-roupas',
      'shelves_outlined',
      ServiceCategory.furniture),
  furnitureTable(
      'Mesas e Cadeiras',
      'Transporte de mesas, cadeiras e móveis de jantar',
      'table_restaurant_outlined',
      ServiceCategory.furniture),

  // Categoria: Eletrodomésticos
  applianceWhite('Linha Branca', 'Geladeira, fogão, máquina de lavar, etc.',
      'kitchen_outlined', ServiceCategory.appliances),
  applianceBrown('Linha Marrom', 'TV, som, computador, etc.', 'tv_outlined',
      ServiceCategory.appliances),
  applianceAC('Ar Condicionado', 'Instalação e transporte de ar condicionado',
      'ac_unit_outlined', ServiceCategory.appliances),

  // Categoria: Entrega Expressa
  expressDelivery(
      'Entrega Expressa',
      'Entrega rápida de encomendas e documentos',
      'local_shipping_outlined',
      ServiceCategory.express),
  expressDocument('Documentos', 'Entrega de documentos importantes',
      'description_outlined', ServiceCategory.express),
  expressFood('Delivery de Comida', 'Entrega de alimentos e bebidas',
      'restaurant_outlined', ServiceCategory.express),

  // Categoria: Materiais de Construção
  constructionMaterial(
      'Materiais de Construção',
      'Cimento, tijolos, areia, etc.',
      'construction_outlined',
      ServiceCategory.construction),
  constructionTools('Ferramentas', 'Transporte de ferramentas e equipamentos',
      'build_outlined', ServiceCategory.construction),

  // Categoria: Outros
  other('Outros Itens', 'Itens não categorizados', 'category_outlined',
      ServiceCategory.other);

  final String label;
  final String description;
  final String icon;
  final ServiceCategory category;

  const EServiceTypes(this.label, this.description, this.icon, this.category);
  static List<EServiceTypes> getByCategory(ServiceCategory category) {
    return EServiceTypes.values.where((type) => type.category == category).toList();
  }
}

enum ServiceCategory {
  moving(
      'Mudança Completa',
      'Para mudanças residenciais e comerciais completas',
      'home_work_outlined'),
  furniture('Transporte de Móveis', 'Para móveis específicos e estofados',
      'chair_outlined'),
  appliances('Eletrodomésticos',
      'Para equipamentos eletrônicos e eletrodomésticos', 'kitchen_outlined'),
  express('Entrega Expressa', 'Para entregas rápidas e documentos',
      'local_shipping_outlined'),
  construction('Materiais de Construção',
      'Para materiais e ferramentas', 'construction_outlined'),
  other('Outros', 'Para itens não categorizados', 'category_outlined');

  final String label;
  final String description;
  final String icon;

  const ServiceCategory(this.label, this.description, this.icon);
}
