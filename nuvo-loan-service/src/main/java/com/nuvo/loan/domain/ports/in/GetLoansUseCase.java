package com.nuvo.loan.domain.ports.in;

import com.nuvo.loan.domain.model.Loan;
import java.util.List;

public interface GetLoansUseCase {
    List<Loan> getAllLoans();

    List<Loan> getLoansByUserId(Integer userId);

    Loan getLoanById(Long loanId);
}
