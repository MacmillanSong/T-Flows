!==============================================================================!
  subroutine Sort_Mod_Real_By_Index(x,indx,n)
!------------------------------------------------------------------------------!
!   Sorts real array x according to indx.                                      !
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  integer :: n, indx(n)
  real    :: x(n)
!-----------------------------------[Locals]-----------------------------------!
  integer           :: i
  real, allocatable :: work(:)
!==============================================================================!

  allocate(work(n)); work = 0.0

  do i = 1, n
    work(indx(i)) = x(i)
  end do

  do i = 1, n
    x(i) = work(i)
  end do

  deallocate(work)

  end subroutine
