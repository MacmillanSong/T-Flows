!==============================================================================!
  subroutine User_Mod_Source(flow, phi, a_matrix, b_vector)
!------------------------------------------------------------------------------!
!   This is a prototype of a function for customized source for scalar.        !
!   It is called from "Compute_Scalar" function, just before calling the       !
!   linear solver.  Both system matrix ("a_matrix") and right hand side        !
!   vector ("b_vector") are sent should the user want to stabilize the         !
!   system for always positive variables, for example.                         !
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Field_Mod,  only: Field_Type, heat_flux, heat, heated_area
  use Grid_Mod,   only: Grid_Type
  use Var_Mod,    only: Var_Type
  use Matrix_Mod, only: Matrix_Type
  use Bulk_Mod,   only: Bulk_Type
  use Comm_Mod
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  type(Field_Type), target :: flow
  type(Var_Type),   target :: phi
  type(Matrix_Type)        :: a_matrix
  real, dimension(:)       :: b_vector
!----------------------------------[Locals]------------------------------------!
  type(Grid_Type), pointer :: grid
  type(Bulk_Type), pointer :: bulk
  type(Var_Type),  pointer :: u, v, w, t
  real,            pointer :: flux(:)
  integer                  :: c
!==============================================================================!

  ! Take aliases
  grid => flow % pnt_grid
  flux => flow % flux
  bulk => flow % bulk
  u    => flow % u
  v    => flow % v
  w    => flow % w
  t    => flow % t

  !-----------------------------------------------------! 
  !                                                     !
  !   Set source depending on which variable you have   !
  !                                                     !
  !-----------------------------------------------------! 

  !-------------------------------!
  !  Set source for temperature   !
  !-------------------------------!
  if( phi % name .eq. 'T' ) then

    call Comm_Mod_Global_Sum_Real(heat_flux)
    call Comm_Mod_Global_Sum_Real(heated_area)
    heat_flux = heat_flux / (heated_area + TINY)
    heat      = heat_flux * heated_area
      
    do c = 1, grid % n_cells
      b_vector(c) = b_vector(c)   &
                  - heat_flux * u % n(c) / bulk % flux_x * grid % vol(c)
    end do
  end if

  !---------------------------------------------!
  !  Set source for turbulent kintetic energy   !
  !---------------------------------------------!
  if( phi % name .eq. 'KIN' ) then

  end if

  !---------------------------!
  !  Set source for epsilon   !
  !---------------------------!
  if( phi % name .eq. 'EPS' ) then

  end if

  end subroutine  ! fourth level comments
