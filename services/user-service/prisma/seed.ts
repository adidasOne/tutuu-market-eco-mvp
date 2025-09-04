import { PrismaClient, UserRole, Gender, DeviceType } from '../src/generated/prisma';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Начинаем заполнение базы данных тестовыми данными...');

  // Очищаем существующие данные
  await prisma.delivery.deleteMany();
  await prisma.order.deleteMany();
  await prisma.userVerification.deleteMany();
  await prisma.userSession.deleteMany();
  await prisma.userProfile.deleteMany();
  await prisma.user.deleteMany();

  console.log('🧹 База данных очищена');

  // Создаем тестовых пользователей
  const passwordHash = await bcrypt.hash('password123', 12);

  // 1. Администратор
  const admin = await prisma.user.create({
    data: {
      email: 'admin@tutuumarket.ru',
      phone: '+7 (999) 123-45-67',
      passwordHash,
      role: UserRole.ADMIN,
      isActive: true,
      isVerified: true,
      emailVerified: true,
      phoneVerified: true,
      profile: {
        create: {
          firstName: 'Администратор',
          lastName: 'Системы',
          companyName: 'TUTUU MARKET',
          companyPosition: 'Системный администратор',
          companyAddress: 'г. Москва, ул. Примерная, д. 1',
          companyPhone: '+7 (495) 123-45-67',
          companyWebsite: 'https://tutuumarket.ru',
          preferences: {
            theme: 'dark',
            language: 'ru',
            notifications: {
              email: true,
              push: true,
              sms: false
            }
          }
        }
      }
    }
  });

  // 2. Продавец
  const seller = await prisma.user.create({
    data: {
      email: 'seller@example.ru',
      phone: '+7 (999) 234-56-78',
      passwordHash,
      role: UserRole.SELLER,
      isActive: true,
      isVerified: true,
      emailVerified: true,
      phoneVerified: true,
      profile: {
        create: {
          firstName: 'Иван',
          lastName: 'Петров',
          middleName: 'Сергеевич',
          birthDate: new Date('1985-03-15'),
          gender: Gender.MALE,
          companyName: 'ООО "СтройМатериалы"',
          companyPosition: 'Директор',
          companyAddress: 'г. Санкт-Петербург, ул. Строительная, д. 15',
          companyPhone: '+7 (812) 234-56-78',
          companyWebsite: 'https://stroymaterial.ru',
          taxId: '1234567890',
          bankAccount: '40702810123456789012',
          preferences: {
            theme: 'light',
            language: 'ru',
            notifications: {
              email: true,
              push: true,
              sms: true
            }
          }
        }
      }
    }
  });

  // 3. Покупатель
  const customer = await prisma.user.create({
    data: {
      email: 'customer@example.ru',
      phone: '+7 (999) 345-67-89',
      passwordHash,
      role: UserRole.CUSTOMER,
      isActive: true,
      isVerified: true,
      emailVerified: true,
      phoneVerified: true,
      profile: {
        create: {
          firstName: 'Мария',
          lastName: 'Иванова',
          middleName: 'Александровна',
          birthDate: new Date('1990-07-22'),
          gender: Gender.FEMALE,
          companyName: 'ИП "Ремонт и Отделка"',
          companyPosition: 'Индивидуальный предприниматель',
          companyAddress: 'г. Екатеринбург, ул. Ремонтная, д. 7',
          companyPhone: '+7 (343) 345-67-89',
          taxId: '9876543210',
          preferences: {
            theme: 'auto',
            language: 'ru',
            notifications: {
              email: true,
              push: false,
              sms: false
            }
          }
        }
      }
    }
  });

  // 4. Перевозчик
  const carrier = await prisma.user.create({
    data: {
      email: 'carrier@example.ru',
      phone: '+7 (999) 456-78-90',
      passwordHash,
      role: UserRole.CARRIER,
      isActive: true,
      isVerified: true,
      emailVerified: true,
      phoneVerified: true,
      profile: {
        create: {
          firstName: 'Алексей',
          lastName: 'Сидоров',
          middleName: 'Владимирович',
          birthDate: new Date('1988-11-08'),
          gender: Gender.MALE,
          companyName: 'ИП "Быстрая Доставка"',
          companyPosition: 'Перевозчик',
          companyAddress: 'г. Новосибирск, ул. Транспортная, д. 25',
          companyPhone: '+7 (383) 456-78-90',
          taxId: '1122334455',
          bankAccount: '40802810111223344556',
          preferences: {
            theme: 'light',
            language: 'ru',
            notifications: {
              email: false,
              push: true,
              sms: true
            }
          }
        }
      }
    }
  });

  // 5. Модератор
  const moderator = await prisma.user.create({
    data: {
      email: 'moderator@tutuumarket.ru',
      phone: '+7 (999) 567-89-01',
      passwordHash,
      role: UserRole.MODERATOR,
      isActive: true,
      isVerified: true,
      emailVerified: true,
      phoneVerified: true,
      profile: {
        create: {
          firstName: 'Елена',
          lastName: 'Козлова',
          middleName: 'Дмитриевна',
          birthDate: new Date('1992-05-12'),
          gender: Gender.FEMALE,
          companyName: 'TUTUU MARKET',
          companyPosition: 'Модератор контента',
          companyAddress: 'г. Москва, ул. Примерная, д. 1',
          companyPhone: '+7 (495) 567-89-01',
          preferences: {
            theme: 'dark',
            language: 'ru',
            notifications: {
              email: true,
              push: true,
              sms: false
            }
          }
        }
      }
    }
  });

  console.log('👥 Создано пользователей:', {
    admin: admin.id,
    seller: seller.id,
    customer: customer.id,
    carrier: carrier.id,
    moderator: moderator.id
  });

  // Создаем тестовые сессии
  const adminSession = await prisma.userSession.create({
    data: {
      userId: admin.id,
      deviceId: 'admin-device-001',
      deviceType: DeviceType.DESKTOP,
      deviceInfo: {
        browser: 'Chrome',
        os: 'Windows 11',
        version: '120.0.0.0'
      },
      ipAddress: '192.168.1.100',
      userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      refreshToken: 'admin-refresh-token-001',
      accessToken: 'admin-access-token-001',
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 дней
      isActive: true
    }
  });

  const customerSession = await prisma.userSession.create({
    data: {
      userId: customer.id,
      deviceId: 'customer-device-001',
      deviceType: DeviceType.MOBILE,
      deviceInfo: {
        browser: 'Safari',
        os: 'iOS 17',
        version: '17.0.0'
      },
      ipAddress: '192.168.1.101',
      userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)',
      refreshToken: 'customer-refresh-token-001',
      accessToken: 'customer-access-token-001',
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 дней
      isActive: true
    }
  });

  console.log('🔐 Создано сессий:', {
    adminSession: adminSession.id,
    customerSession: customerSession.id
  });

  // Создаем тестовые заказы
  const customerOrder = await prisma.order.create({
    data: {
      userId: customer.id,
      orderNumber: 'ORD-2025-001',
      status: 'PENDING',
      totalAmount: 15000.50,
      currency: 'RUB'
    }
  });

  const sellerOrder = await prisma.order.create({
    data: {
      userId: seller.id,
      orderNumber: 'ORD-2025-002',
      status: 'CONFIRMED',
      totalAmount: 25000.00,
      currency: 'RUB'
    }
  });

  console.log('📦 Создано заказов:', {
    customerOrder: customerOrder.id,
    sellerOrder: sellerOrder.id
  });

  // Создаем тестовые доставки
  const delivery1 = await prisma.delivery.create({
    data: {
      userId: customer.id,
      orderId: customerOrder.id,
      status: 'PENDING',
      estimatedDelivery: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000) // 3 дня
    }
  });

  const delivery2 = await prisma.delivery.create({
    data: {
      userId: seller.id,
      orderId: sellerOrder.id,
      status: 'ASSIGNED',
      carrierId: carrier.id,
      estimatedDelivery: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000) // 2 дня
    }
  });

  console.log('🚚 Создано доставок:', {
    delivery1: delivery1.id,
    delivery2: delivery2.id
  });

  console.log('✅ База данных успешно заполнена тестовыми данными!');
  console.log('\n📊 Статистика:');
  console.log('- Пользователей: 5');
  console.log('- Сессий: 2');
  console.log('- Заказов: 2');
  console.log('- Доставок: 2');
  console.log('\n🔑 Тестовые учетные данные:');
  console.log('- Email: admin@tutuumarket.ru, Password: password123');
  console.log('- Email: seller@example.ru, Password: password123');
  console.log('- Email: customer@example.ru, Password: password123');
  console.log('- Email: carrier@example.ru, Password: password123');
  console.log('- Email: moderator@tutuumarket.ru, Password: password123');
}

main()
  .catch((e) => {
    console.error('❌ Ошибка при заполнении базы данных:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
