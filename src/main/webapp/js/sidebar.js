/**
 * 
 */

// 아코디언 동작 스크립트
function toggleAccordion(headerElement) {
  const group = headerElement.parentElement;
  const content = group.querySelector('.nav-group-content');
  
  // Toggle current
  if (group.classList.contains('open')) {
    group.classList.remove('open');
    content.style.maxHeight = null;
  } else {
    group.classList.add('open');
    content.style.maxHeight = content.scrollHeight + "px";
  }
}

// 페이지 로드 시 'open' 클래스가 있는 그룹의 max-height 초기화
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('.nav-group.open .nav-group-content').forEach(content => {
    content.style.maxHeight = content.scrollHeight + "px";
  });
});