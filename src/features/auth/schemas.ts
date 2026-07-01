import { z } from 'zod'

export const loginSchema = z.object({
  email: z.string().email('Email non valida'),
  password: z.string().min(6, 'Password di almeno 6 caratteri'),
})

export const registerSchema = z.object({
  username: z
    .string()
    .min(3, 'Username di almeno 3 caratteri')
    .max(30, 'Username massimo 30 caratteri')
    .regex(/^[a-z0-9_]+$/, 'Solo lettere minuscole, numeri e underscore'),
  display_name: z.string().min(2, 'Nome di almeno 2 caratteri').max(50),
  email: z.string().email('Email non valida'),
  password: z.string().min(8, 'Password di almeno 8 caratteri'),
})

export const forgotPasswordSchema = z.object({
  email: z.string().email('Email non valida'),
})

export type LoginData = z.infer<typeof loginSchema>
export type RegisterData = z.infer<typeof registerSchema>
export type ForgotPasswordData = z.infer<typeof forgotPasswordSchema>
